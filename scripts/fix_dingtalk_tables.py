#!/usr/bin/env python3
"""修复从钉钉复制出来的 Markdown 纵向合并表格。

钉钉允许“群控工具”单元格跨多行，标准 Markdown 不支持 rowspan。
复制后，合并范围内后续行会整体左移一列。本脚本把最近一次出现的
“群控工具”补到每一行，使 Typora、GitHub 等 Markdown 渲染器稳定显示。
"""

from __future__ import annotations

import argparse
import difflib
import os
import re
import sys
import tempfile
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
DEFAULT_README = SCRIPT_DIR.parent / "README.md"
STATUS_VALUES = {"✅", "❌", "是", "否", "yes", "no", "true", "false"}
SEPARATOR_CELL = re.compile(r"^:?-{3,}:?$")


def split_markdown_row(line: str) -> list[str] | None:
    """按未转义的竖线拆分 Markdown 表格行。"""
    stripped = line.strip()
    if not (stripped.startswith("|") and stripped.endswith("|")):
        return None

    cells: list[str] = []
    current: list[str] = []
    escaped = False
    for char in stripped[1:-1]:
        if escaped:
            current.append(char)
            escaped = False
        elif char == "\\":
            current.append(char)
            escaped = True
        elif char == "|":
            cells.append("".join(current).strip())
            current = []
        else:
            current.append(char)
    cells.append("".join(current).strip())
    return cells


def is_separator(cells: list[str] | None) -> bool:
    return bool(cells) and all(SEPARATOR_CELL.fullmatch(cell) for cell in cells)


def format_markdown_row(cells: list[str], newline: str) -> str:
    return "| " + " | ".join(cells) + " |" + newline


def normalized(value: str) -> str:
    return value.strip().lower()


def repair(content: str, source: Path) -> tuple[str, int]:
    lines = content.splitlines(keepends=True)
    repaired_rows = 0
    index = 0

    while index + 1 < len(lines):
        headers = split_markdown_row(lines[index])
        separator = split_markdown_row(lines[index + 1])
        if not headers or not is_separator(separator) or headers[0].strip() != "群控工具":
            index += 1
            continue

        column_count = len(headers)
        current_tool = ""
        row_index = index + 2
        while row_index < len(lines):
            cells = split_markdown_row(lines[row_index])
            if cells is None:
                break
            if len(cells) != column_count:
                raise ValueError(
                    f"{source}:{row_index + 1}: 表格应有 {column_count} 列，"
                    f"实际为 {len(cells)} 列；为避免丢失内容，已停止修改。"
                )

            original_cells = list(cells)
            second_cell = normalized(cells[1]) if len(cells) > 1 else ""

            if second_cell in STATUS_VALUES:
                if not current_tool:
                    raise ValueError(
                        f"{source}:{row_index + 1}: 风险标签行缺少可继承的群控工具。"
                    )
                # 钉钉省略了纵向合并的第一列，其余列整体左移；末尾为空占位列。
                if cells[-1]:
                    raise ValueError(
                        f"{source}:{row_index + 1}: 左移行的最后一列不是空值；"
                        "为避免覆盖内容，已停止修改。"
                    )
                cells = [current_tool, *cells[:-1]]
            elif not cells[0]:
                if current_tool:
                    cells[0] = current_tool
            else:
                current_tool = cells[0]

            if cells != original_cells:
                newline = "\r\n" if lines[row_index].endswith("\r\n") else "\n"
                if not lines[row_index].endswith(("\n", "\r")):
                    newline = ""
                lines[row_index] = format_markdown_row(cells, newline)
                repaired_rows += 1
            row_index += 1

        index = row_index

    return "".join(lines), repaired_rows


def atomic_write(path: Path, content: str) -> None:
    mode = path.stat().st_mode
    with tempfile.NamedTemporaryFile(
        mode="w", encoding="utf-8", newline="", dir=path.parent, delete=False
    ) as temporary:
        temporary.write(content)
        temporary_path = Path(temporary.name)
    os.chmod(temporary_path, mode)
    os.replace(temporary_path, path)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "file", nargs="?", type=Path, default=DEFAULT_README,
        help=f"待修复文件，默认：{DEFAULT_README}",
    )
    parser.add_argument(
        "--check", action="store_true",
        help="只检查是否需要修复，不写入文件；需要修复时返回状态码 1。",
    )
    parser.add_argument(
        "--dry-run", action="store_true",
        help="打印修复前后的差异，不写入文件。",
    )
    args = parser.parse_args()

    target = args.file.expanduser().resolve()
    original = target.read_text(encoding="utf-8")
    repaired, repaired_rows = repair(original, target)

    if args.dry_run and repaired != original:
        sys.stdout.writelines(difflib.unified_diff(
            original.splitlines(keepends=True),
            repaired.splitlines(keepends=True),
            fromfile=str(target),
            tofile=str(target) + " (fixed)",
        ))

    if args.check:
        if repaired_rows:
            print(f"需要修复 {repaired_rows} 行：{target}")
            return 1
        print(f"无需修复：{target}")
        return 0

    if args.dry_run:
        print(f"\n预览完成，共识别 {repaired_rows} 行；未写入文件。")
        return 0

    if repaired_rows:
        atomic_write(target, repaired)
        print(f"已修复 {repaired_rows} 行：{target}")
    else:
        print(f"无需修复：{target}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
