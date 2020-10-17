# WordPress Git Post

WordPress has provided a command line tool [WP-CLI](https://make.wordpress.org/cli/handbook/) that enables you make new posts via a command line. That's not convenient enough, we want it better.

In this project, we dedicated to build a tool that allows you to automatically make or update posts to a WordPress site via Git. Through the abilities provided by the tool you can write markdown files in a local Git repository, when you make a push to the remote Git repository on the the server where your [WordPress](https://wordpress.org) site resides, the changes would be reflected on that live site.

## Ideas

The work are done through Git hooks and custom WP-CLI commands. We build a Git hook to the remote Git repository, it executes the custom WP-CLI command we wrote in the commit message to insert or update posts with markdown files on push.

> **Note:**
>
> The custom WP-CLI command itself does not provide parsing for markdown format content for it may have been enabled by some plugin you are using like [Jetpack](https://wordpress.org/plugins/jetpack). Therefore you need to enable markdown feature through any plugin you like to make the content being displayed as proper HTML in the front.

## Getting started

### Prerequisites

1. **Build Git repositories**

   Build a local Git repository on local machine and a remote one on the server. The remote repository needs to be a non-bare one.

   To make pushes to a non-bare remote repository, configure the remote repository to allow them.

   ```shell
   # Config receive.denyCurrentBranch to allow the push and
   # update the current branch.
   $ git config receive.denyCurrentBranch updateInstead
   ```

   Copy `commit.sh` to `.git` folder of the repository and execute `chmod a+x commit.sh` (only for Linux) to make it executable.

   Then set up SSH access to the remote repository. See [Setting up the server](https://git-scm.com/book/en/v2/Git-on-the-Server-Setting-Up-the-Server) for reference if you are not familiar to that.

2. **Install WP-CLI tool**

   First, download [wp-cli.phar](https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar). On Linux using using `wget` or `curl`. Installing it on Linux:

   ```shell
   # Download wp-cli
   $ curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
   # Make it executable.
   $ chmod +x wp-cli.phar
   # Rename it for less typing and move it somewhere in your path.
   $ sudo mv wp-cli.phar /usr/local/bin/wp
   ```

   On Windows, it is similar.

   See [Installing WP-CLI](https://make.wordpress.org/cli/handbook/guides/installing/) for more details.

### Installing

The installing is simple, just some copy operations. You need install Git hooks and WP-CLI commands:

- **Install hooks**

  Copy hooks inside server-hooks folder to the `.git/hooks` to the remote repository. Optionally copy hooks inside server-hooks folder to the `.git/hooks` in the local repository.

  > **Note:**
  >
  > If your WordPress site is running on Windows, change `post-receive` file to make it work properly on Windows as following steps. Otherwise you may meet `'wp' is not recognized as an internal or external command` error.
  >
  > Change below line in `post-receive` file
  >
  > ```php
  > define( "WP_CLI_TOOL", "wp " );
  > ```
  >
  > to
  >
  > ```php
  > define( "WP_CLI_TOOL", "php <wp-path> " );
  > ```
  >
  > Use your own path to `wp` file to replace  `<wp-path>`. Be care that there is a space in the end.

- **Install custom WP-CLI commands**

  Copy `wp-cli-markdown-post-command.php` to your current using theme and include it in the `functions.php` file on the server. Take care to use different code depending on whether you are using a parent theme or a child theme (name ends with `-child`).

  ```php
  // Use below code if you are using a parent theme.
  if ( defined( 'WP_CLI' ) && WP_CLI ) {
      require_once( get_parent_theme_file_path() . '/wp-cli-markdown-post-command.php' );
  }

  // Use below code if you are using a child theme.
  if ( defined( 'WP_CLI' ) && WP_CLI ) {
      require_once( get_stylesheet_directory() . '/wp-cli-markdown-post-command.php' );
  }
  ```

## Usage

To insert or update a new post with a markdown file through Git, you need to write the command in the commit message with the form `cmd: wp <command-name> <markdown-file-path-relative-to-the-repository-root>`. Below are some examples:

```shell
# Create a new post
$ git commit -m 'cmd: wp create git/userfule-git-commands.md'

# Update a post
$ git commit -m 'cmd: wp update git/userfule-git-commands.md'
```

## Authors

- *Initial work* - [Gloomic](https://github.com/gloomic)

## License

This project is licensed under the [GPLv2](https://www.gnu.org/licenses/gpl-2.0.html) License.

## Contact

Feel free to contact me on [GloomyCorner](https://www.gloomycorner.com/contact/).