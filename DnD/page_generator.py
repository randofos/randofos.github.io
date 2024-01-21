import os
import json
from jinja2 import *

env = Environment(
    loader=PackageLoader(package_name="jinja"),
    autoescape=select_autoescape()
)


def main():
    directory = os.path.join(os.getcwd(), "jinja", "data")
    template  = env.get_template("base.jinja")
    for subdirectory, directories, files in os.walk(directory):
        for filename in files:
            file_path = os.path.join(subdirectory, filename)
            print("Generating "+filename)
            if os.path.isfile(file_path):
                sub_path    = subdirectory.removeprefix(directory)
                data_file   = open(file_path)
                if sub_path:
                    sub_path = sub_path.removeprefix("\\")
                    output_file = open(sub_path + "_" + filename.rsplit(".")[0] + ".html", "wb")
                else:
                    output_file = open(filename.split(".")[0] + ".html", "wb")
                output_file.write(template.render(data=json.load(data_file)).encode('utf-8'))
                output_file.close()
                data_file.close()


if __name__ == "__main__":
    main()
