import sys

def main():
    config_filepath = sys.argv[1]
    vc_names = stringsFromFilepath(sys.argv[2])
    vc_usernames = stringsFromFilepath(sys.argv[3])
    vc_passwords = stringsFromFilepath(sys.argv[4])
    vc_verifys = [s.lower() for s in stringsFromFilepath(sys.argv[5])]

    vcenters_yaml_str = 'vcs:\n'
    for i, name in enumerate(vc_names):
        vcenters_yaml_str += (
            f'- name: {name}\n'
            f'  username: {vc_usernames[i]}\n'
            f'  password: {vc_passwords[i]}\n'
            f'  verify: {vc_verifys[i]}\n'
        )

    lines = []
    with open(config_filepath) as f:
        lines = f.readlines()

    with open(config_filepath, 'w') as f:
        in_vc_section = False
        for line in lines:
            if 'vcs:' in line:
                in_vc_section = True
            if in_vc_section and line == '\n':
                in_vc_section = False
            if not in_vc_section:
                f.write(line)
        f.write(vcenters_yaml_str)

def stringsFromFilepath(filepath):
    with open(filepath) as f:
        return [s.strip() for s in f.readline().split(',')]

if __name__ == "__main__":
    main()
