from os import sep, getenv
import inspect

__build_dir_env = "BUILD_DIR"

def generate_filename():
    caller_frame = inspect.stack()[1]
    caller_module = inspect.getmodule(caller_frame[0])
    caller_module_name = caller_module.__spec__.name

    build_dir = getenv(__build_dir_env)

    parts:list[str] = []
    if build_dir:
        parts = caller_module_name.split('.')
        parts = [build_dir] + parts[2:]
    else:
        parts.append(caller_module_name.split('.')[-1])

    return sep.join(parts)
