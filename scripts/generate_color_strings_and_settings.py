"""
Loads available colors from templates/available_colors.yml.
Generates formatted/strings.xml and formatted/settings.xml based on
the templates strings.xml and settings.xml
"""

import yaml
import os

KEY_YAML_COLORS = 'colors'

KEY_ID = '[id]'
KEY_VALUE = '[value]'
KEY_LIST_ENTRY_COLOR = '[ListEntry.Colors]'
KEY_STRING_COLOR = '[String.Colors]'

COLOR_PREFIX = 'ColorValue'
RESULT_FOLDER = 'formatted'


def load_available_colors(path):
    with open(path, 'r') as f:
        d = yaml.load(f.read())
        return d.get(KEY_YAML_COLORS)


def load_one_line_template(path):
    with open(path, 'r') as f:
        template = f.read().strip()
        return template


def format_color(color):
    color = color.replace('Graphics.COLOR_', '')
    color = color.replace('DK', 'dark')
    color = color.replace('LT', 'light')
    color = color.replace('_', ' ')
    
    # capitalize first letter
    color = color.capitalize()
    return color


def format_color_id(color):
    return COLOR_PREFIX + color.title().replace(' ', '')


def get_color_strings(colors, string_template):
    color_strings = []
    
    for c in colors:
        c = format_color(c)
        color_id = format_color_id(c)
        color_str = string_template.replace(KEY_ID, color_id).replace(KEY_VALUE, c)
        color_strings.append(color_str)
    
    return '\n'.join(color_strings)


def get_color_list_entries(colors, list_entry_template):
    list_entrys = []
    
    for i, c in enumerate(colors):
        c = format_color(c)
        color_id = format_color_id(c)
        color_str = list_entry_template.replace(KEY_ID, color_id).replace(KEY_VALUE, str(i))
        list_entrys.append(color_str)
        
    return '\n'.join(list_entrys)

    
def format_and_save_template(key, new_value, path):
    os.makedirs(RESULT_FOLDER, exist_ok=True)
    
    basename = os.path.basename(path)
    target = os.path.join(RESULT_FOLDER, basename)
    
    with open(path, 'r') as f:
        template = f.read()
        template = template.replace(key, new_value)
        with open(target, 'w') as out:
            out.write(template)

    
def main():
    colors = load_available_colors('templates/available_colors.yml')
    string_template = load_one_line_template('templates/string.xml')
    list_entry_template = load_one_line_template('templates/listEntry.xml')
    
    strings = get_color_strings(colors, string_template)
    list_entrys = get_color_list_entries(colors, list_entry_template)
    
    print(strings)
    print(list_entrys)
    
    format_and_save_template(KEY_STRING_COLOR, strings, 'templates/strings.xml')
    format_and_save_template(KEY_LIST_ENTRY_COLOR, list_entrys, 'templates/settings.xml')

    
if __name__ == '__main__':
    main()
    
