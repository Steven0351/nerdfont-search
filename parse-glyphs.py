#!/usr/bin/env python3

import re
import sys

def parse_glyphs(input_file, output_file):
    """Parse the glyphs JavaScript object and convert to icon data."""
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract all "name": "hex" pairs
    pattern = r'"([^"]+)":\s*"([0-9a-fA-F]+)"'
    matches = re.findall(pattern, content)

    converted_count = 0
    skipped_count = 0

    with open(output_file, 'w', encoding='utf-8') as f:
        for name, hex_code in matches:
            # Skip removed/old icons (nfold- prefix)
            if name.startswith('nfold-'):
                skipped_count += 1
                continue

            try:
                # Convert hex to Unicode character
                char = chr(int(hex_code, 16))
                # Add space after icon for proper rendering (some icons need two cells)
                f.write(f"{name:<40} {char} \n")
                converted_count += 1
            except ValueError:
                print(f"Warning: Could not convert {name}: {hex_code}", file=sys.stderr)

    print(f"Converted {converted_count} icons to {output_file} (skipped {skipped_count} removed icons)")

if __name__ == "__main__":
    import os

    share_dir = os.environ.get('NERDFONT_SHARE_DIR')
    if share_dir:
        base_dir = share_dir
    else:
        base_dir = os.path.dirname(os.path.abspath(__file__))

    input_file = os.path.join(base_dir, 'data', 'glyphs.js')
    output_file = os.path.join(base_dir, 'nerd-fonts-data.txt')
    parse_glyphs(input_file, output_file)
