# WordPress Git Post

WordPress has provided a command line tool [WP-CLI](https://make.wordpress.org/cli/handbook/) that enables you make new posts via a command line. That's not convenient enough, you need to transfer the files to the server and write long commands with too many arguments to create or update posts.

In this project, we dedicated to build a tool that allows you to automatically make or update posts to a WordPress site via Git. Through the abilities provided by the tool you can write markdown files in a local Git repository, when you make a push to the remote repository on the server where your [WordPress](https://wordpress.org) site resides, the changes would be reflected on that live site.

## Ideas

The work are done through Git hooks and custom WP-CLI commands. We build a Git hook to the remote Git repository, it executes the custom WP-CLI command we wrote in the commit message to insert or update posts with markdown files on push.

> **Note:**
>
> The custom WP-CLI command itself does not provide parsing for markdown format content for it may have been enabled by some plugin you are using like [Jetpack](https://wordpress.org/plugins/jetpack). Therefore you need to enable markdown feature through any plugin you like to make the content being displayed as proper HTML in the front.

## Getting started

### Prerequisites

1. **Build Git repositories**

   Build a local Git repository on local machine and a remote one on the server. The remote repository needs to be a non-bare one.

   To be able to push to a non-bare remote repository, configure the remote repository to allow them.

   ```shell
   # Config receive.denyCurrentBranch to allow the push and
   # update the current branch.
   $ git config receive.denyCurrentBranch updateInstead
   ```

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

  Copy `post-receive` file inside `server-hooks` folder to the `.git/hooks` folder of the remote repository. Execute `chmod a+x post-receive` (for Linux) under `.git/hooks` folder to make it executable.

  > **Note:**
  >
  > If your WordPress site is running on Windows, change `post-receive` file to make it work properly as following steps. Otherwise you may meet `'wp' is not recognized as an internal or external command` error.
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

  Copy `wp-cli-markdown-post-command.php` to your current using theme on the server. To make it workd add below content to the `functions.php` file. Take care to use different code depending on whether you are using a parent theme or a child theme (name ends with `-child`).

  If you are using a parent theme:
  
  ```php
  // Use below code if you are using a parent theme.
  if ( defined( 'WP_CLI' ) && WP_CLI ) {
      require_once( get_parent_theme_file_path() . '/wp-cli-markdown-post-command.php' );
  }
  ```
  
  Or if you are using a child theme:
  
  ```php
  // Use below code if you are using a child theme.
  if ( defined( 'WP_CLI' ) && WP_CLI ) {
      require_once( get_stylesheet_directory() . '/wp-cli-markdown-post-command.php' );
  }
  ```

## Usage

Configure the local git repository with below commands to set the remote repository:

```shell
$ git remote add origin <remote-repostiory-url>
```

Next what you do is just write or update a markdown file in your local repository, commit it and push to the remote repository. In one commit, it only handle just one single markdown file. 

Below is a full process (see [wp-cli-markdown-post](https://github.com/gloomic/wp-cli-markdown-post) for more details using the custom WP-CLI command):

**Step 1. Write new markdown files or update existing ones**

The raw content of a markdown file looks like below, it have a [YAML](http://www.yaml.org)  part to specify the post meat information like post_title, post_category, etc. If you are using [Yoast](https://yoast.com) (a WordPress SEO plugin), you can set `description`  information, otherwise you can set `post_excerpt` instead.

```markdown
---
post_title: My first post
post_author: 9
post_type: post
post_status: publish
tags_input:
  - demo
post_category:
  - examples
description: In this post, ....
---

You post content here....
```

If your local machine has WordPress site running and you installed WP-CLI and the custom WP-CLI command provided in this tool, you can use `wp new my-first-post` to create a markdown file with empty meta values.

> **Note:**
>
> For modified markdown files, only the description and content will be updated to WordPress site.

**Step 2. Commit the new or modified files**

You can commit multiple new or modified markdown files at a time.

```shell
# Add all the new created or modified files, like "git add examples/my-first-post.md"
$ git add <files>

# Commit the changes
$ git commit -m 'your commit message'
```

**Step 3. Push to the remote repository**

If this is the first time you push, use below command to set local master/main branch to track the remote master/main branch:

```shell
$ git push -u origin master
# Or if your branch is named as main
$ git push -u origin main
```

In the future pushes, just run:

```shell
$ git push
```

When you push one or more commits to the remote repository, it will trigger actions on remote server to create new or update posts with the files in this push. And you will get information about these actions in terminal, like which files are used to create new posts and which ones are used to update posts.

After you make a push, you may need to execute `git pull` command to get updated markdown files that have post `ID` added to them. Otherwise, it will prompt you to do that when you push in the next time.

## Authors

- *Initial work* - [Gloomic](https://github.com/gloomic)

## License

This project is licensed under the [GPLv2](https://www.gnu.org/licenses/gpl-2.0.html) License.

## Contact

Feel free to contact me on [GloomyCorner](https://www.gloomycorner.com/contact/).