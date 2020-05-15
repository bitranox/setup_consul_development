# STDLIB
import argparse
import datetime
import errno
import logging
import os
import sys
import subprocess

# OWN
import lib_log

if sys.version_info < (3, 6):
    lib_log.setup_console_logger()
    main_logger = logging.getLogger('init')
    main_logger.error('only Python Versions from 3.6 are supported')
    sys.exit(1)
else:
    # OWN
    from rst_include import *


# CONSTANTS & PROJECT SPECIFIC FUNCTIONS
codeclimate_link_hash = "ff3f414903627e5cfc35"


def project_specific(repository_slug, repository, repository_dashed):
    # PROJECT SPECIFIC
    logger = logging.getLogger('project_specific')
    logger.info('no project specific steps to build the docs')


def parse_args(cmd_args=sys.argv[1:]):
    # type: ([]) -> []
    parser = argparse.ArgumentParser(
        description='Create Readme.rst',
        epilog='check the documentation on github',
        add_help=True)

    parser.add_argument('travis_repo_slug', metavar='TRAVIS_REPO_SLUG in the form "<github_account>/<repository>"')
    args = parser.parse_args(cmd_args)
    return args, parser


def main(args):
    logger = logging.getLogger('build_docs')
    logger.info('create the README.rst')
    travis_repo_slug = args.travis_repo_slug
    repository = travis_repo_slug.split('/')[1]
    repository_dashed = repository.replace('_', '-')

    project_specific(travis_repo_slug, repository, repository_dashed)

    """
    paths absolute, or relative to the location of the config file
    the notation for relative files is like on windows or linux - not like in python.
    so You might use ../../some/directory/some_document.rst to go two levels back.
    avoid absolute paths since You never know where the program will run.
    """

    logger.info('include the include blocks')
    rst_inc(source='./.docs/README_template.rst',
            target='./.docs/README_template_included.rst')

    # please note that the replace syntax is not shown correctly in the README.rst,
    # because it gets replaced itself by the build_docs.py
    # we could overcome this by first replacing, and afterwards including -
    # check out the build_docs.py for the correct syntax !
    logger.info('replace repository related strings')
    rst_str_replace(source='./.docs/README_template_included.rst',
                    target='./.docs/README_template_repo_replaced.rst',
                    old='{repository_slug}',
                    new=travis_repo_slug)
    rst_str_replace(source='./.docs/README_template_repo_replaced.rst',
                    target='./.docs/README_template_repo_replaced2.rst',
                    old='{repository}',
                    new=repository)
    rst_str_replace(source='./.docs/README_template_repo_replaced2.rst',
                    target='./.docs/README_template_repo_replaced3.rst',
                    old='{repository_dashed}',
                    new=repository_dashed)

    rst_include.rst_str_replace(source='./README.rst', target='', old='{last_update_yyyy}', new=str(datetime.date.today().year+1), inplace=True)

    rst_str_replace(source='./.docs/README_template_repo_replaced3.rst',
                    target='./README.rst',
                    old='{codeclimate_link_hash}',
                    new=codeclimate_link_hash)

    logger.info('cleanup')
    os.remove('./.docs/README_template_included.rst')
    os.remove('./.docs/README_template_repo_replaced.rst')
    os.remove('./.docs/README_template_repo_replaced2.rst')
    os.remove('./.docs/README_template_repo_replaced3.rst')

    logger.info('done')
    sys.exit(0)


if __name__ == '__main__':
    lib_log.setup_console_logger()
    main_logger = logging.getLogger('main')
    try:
        _args, _parser = parse_args()
        main(_args)
    except FileNotFoundError:
        # see https://www.thegeekstuff.com/2010/10/linux-error-codes for error codes
        sys.exit(errno.ENOENT)      # No such file or directory
    except FileExistsError:
        sys.exit(errno.EEXIST)      # File exists
    except TypeError:
        sys.exit(errno.EINVAL)      # Invalid Argument
    except ValueError:
        sys.exit(errno.EINVAL)      # Invalid Argument
