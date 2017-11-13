"""Save aws temporary credentials and settings to profile in config file """
import json
import configparser
import argparse
import os
import time
import webbrowser
from urllib.parse import urljoin
import boto3
import botocore

def main():
    args = get_args()

    profile = args.profile
    account_role = args.account_role
    sso_proxy_url = args.sso_proxy_url

    #if the current profile is ok do not overwrite
    if test_profile_config(profile) is True:
        print("Profile configuration test successful")
    else:
        profile_config = get_profile_config(sso_proxy_url, account_role)
        save_profile_config(profile, profile_config)
        print('Profile configuration saved')
        if test_profile_config(profile) is True:
            print("Profile configuration test successful")
        else:
            print("Profile configuration test failed")

def get_args():
    argument_parser = argparse.ArgumentParser()
    argument_parser.add_argument(
        "--account_role",
        required=True,
        help='name of aws account and role'
        )
    argument_parser.add_argument(
        "--profile",
        default='default',
        help='profile where the credentials and other config will be saved'
        )
    argument_parser.add_argument(
        "--sso_proxy_url",
        default='https://awsazuressoproxy.ipreo.com/',
        help='url of aws azure sso proxy'
        )
    args = argument_parser.parse_args()
    return args

def get_download_path(account_role):
    return os.path.expanduser('~/Downloads/%s.json' % account_role)

def wait_path_exists(path):
    while True:
        if os.path.exists(path):
            break
        time.sleep(1)

def get_profile_config_from_path(path):
    with open(path) as file:
        profile_config = json.load(file)
    return profile_config

def get_profile_config(sso_proxy_url, account_role):
    download_path = get_download_path(account_role)

    if os.path.exists(download_path):
        os.remove(download_path)

    sso_url = urljoin(sso_proxy_url, account_role)
    webbrowser.open(sso_url)
    wait_path_exists(download_path)

    profile_config = get_profile_config_from_path(download_path)

    return profile_config

def save_profile_config(profile, profile_config):
    config_paths = ['~/.aws/config', '~/.aws/credentials']

    for current_path in config_paths:
        #the aws cli config file is in the user's home directory'
        config_path = os.path.expanduser(current_path)

        #if the file is not present config returns an empty config rather than throwing an exception
        config = configparser.RawConfigParser()
        config.read(config_path)

        if not config.has_section(profile):
            config.add_section(profile)

        config.set(profile, 'region', profile_config['RegionName'])
        config.set(profile, 'aws_access_key_id', profile_config['AccessKeyId'])
        config.set(profile, 'aws_secret_access_key', profile_config['SecretAccessKey'])
        config.set(profile, 'aws_session_token', profile_config['SessionToken'])

        with open(config_path, 'w+') as config_file:
            config.write(config_file)

def test_profile_config(profile='default'):
    try:
        session = boto3.Session(profile_name=profile)
        session.client('sts').get_caller_identity()
        return True
    except (botocore.exceptions.ClientError, botocore.exceptions.ProfileNotFound):
        return False

if __name__ == "__main__":
    main()