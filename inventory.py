#!/usr/bin/env python

import json
import argparse
import subprocess


def main():
    inventory = {'all': {'hosts': [], 'vars': {'ansible_user': 'root'}}}
    hostvars = {}

    inventory['client'] = client(hostvars)
    inventory['server'] = server(hostvars)
    inventory['monitor'] = monitor(hostvars)

    for type in ['client', 'server', 'monitor']:
        for host in inventory[type]['hosts']:
            inventory['all']['hosts'].append(host)

    # noqa https://github.com/ansible/ansible/commit/bcaa983c2f3ab684dca6c2c2c8d1997742260761
    inventory['_meta'] = {'hostvars': hostvars}

    parser = argparse.ArgumentParser(description="DO droplet inventory")
    parser.add_argument('--list', action='store_true',
                        help="List DO droplet inventory")
    parser.add_argument('--host', help='List details of a droplet')
    args = parser.parse_args()

    if args.list:
        print(json.dumps(inventory))
    elif args.host:
        print(json.dumps(hostvars.get(args.host, {})))


def client(hostvars):
    client = {'hosts': []}

    for i in range(int(get_scalar_value("client_count"))):
        name = "client%d" % i
        client['hosts'].append(name)

        # Get the public IPv4 for the droplet reachability.
        address = get_array_value("client_public_ipv4", i)
        hostvars[name] = {'ansible_host': address, 'server': {}, 'monitor': {}}
        hostvars[name]['ipv4'] = get_array_value("client_public_ipv4", i)
        hostvars[name]['ipv4_private'] = get_array_value("client_private_ipv4", i)
        hostvars[name]['ipv6'] = get_array_value("client_public_ipv6", i)

        # Setup the server related variables.
        hostvars[name]['server']['ipv4'] = get_array_value("server_public_ipv4", i)
        hostvars[name]['server']['ipv4_private'] = get_array_value("server_private_ipv4", i)
        hostvars[name]['server']['ipv6'] = get_array_value("server_public_ipv6", i)
        hostvars[name]['server']['flip'] = get_array_flip("server_flip", i)
        hostvars[name]['server']['port'] = get_scalar_value("server_port")

        # Setup the monitor related variables.  Use client0 for the default monitoring
        # server for all at the moment.
        hostvars[name]['monitor']['ipv4'] = get_array_value("client_public_ipv4", 0)

    return client


def server(hostvars):
    server = {'hosts': []}

    for i in range(int(get_scalar_value("server_count"))):
        name = "server%d" % i
        server['hosts'].append(name)

        # Get the public IPv4 for the droplet reachability.
        address = get_array_value("server_public_ipv4", i)
        hostvars[name] = {'ansible_host': address, 'server': {}}
        hostvars[name]['ipv4'] = get_array_value("server_public_ipv4", i)
        hostvars[name]['ipv4_private'] = get_array_value("server_private_ipv4", i)
        hostvars[name]['ipv6'] = get_array_value("server_public_ipv6", i)
        hostvars[name]['server']['port'] = get_scalar_value("server_port")

    return server


def monitor(hostvars):
    monitor = {'hosts': []}

    for i in range(int(get_scalar_value("monitor_count"))):
        name = "monitor%d" % i
        monitor['hosts'].append(name)

        # Get the public IPv4 for the droplet reachability.
        address = get_array_value("monitor_public_ipv4", i)
        hostvars[name] = {'ansible_host': address}
        hostvars[name]['ipv4'] = get_array_value("monitor_public_ipv4", i)
        hostvars[name]['ipv4_private'] = get_array_value("monitor_private_ipv4", i)
        hostvars[name]['ipv6'] = get_array_value("monitor_public_ipv6", i)

    return monitor


def get_scalar_value(value):
    return subprocess.Popen("terraform output %s" % value,
                            shell=True, stdout=subprocess.PIPE
                            ).stdout.read().decode('utf-8').strip('\n').replace('"', '')


def get_array_value(value, index):
    return subprocess.Popen("terraform output -json %s|jq '.value[%d]'" % (value, index),
                            shell=True, stdout=subprocess.PIPE
                            ).stdout.read().decode('utf-8').strip('\n').replace('"', '')


def get_array_flip(value, index):
    return subprocess.Popen("cd flips && terraform output -json %s|jq '.value[%d]'" % (value, index),
                            shell=True, stdout=subprocess.PIPE
                            ).stdout.read().decode('utf-8').strip('\n').replace('"', '')


if __name__ == '__main__':
    main()
