# ThELPA: Thornjad's Emacs Lisp Package Archive

This repository is my custom ELPA for maximum control. Primarily used to provide package to [Aero Emacs](https://github.com/thornjad/aero).

The archive is published at https://thornjad.github.io/thelpa/archive/ or recipes can be pulled from this repository directly.

## Updating the archive

Requires that [Cask](https://github.com/cask/cask) is already installed.

``` sh
make
```

### Build without committing

``` sh
make build
```

### Adding or updating a recipe

Add a new recipe file to `recipes/` following the [MELPA Recipe Format](https://github.com/melpa/melpa#recipe-format), then open a pull request with the new or updated recipe file.

## Use the archive from Emacs

### Using package.el

Add ThELPA to your repository list from your configuration, such as in `init.el`:

``` emacs-lisp
(setq package-archives
      `(,@package-archives
        ("thelpa" . "https://thornjad.github.io/thelpa/archive/")))
```

### Using straight.el

Setting up a new package repository in Straight.el is both cumbersome and not too difficult. There's a lot of boilerplate, but setting up ThELPA is almost identical to how Straight.el itself sets up MELPA.

Check out [How Aero Emacs sets up the recipe repository](https://gitlab.com/thornjad/aero/-/blob/main/lib/core/aero-package.el) and also [Straight's documentation](https://github.com/radian-software/straight.el#defining-new-recipe-repositories)

The key points are to define these functions:

- `straight-recipes-thelpa-retrieve`
- `straight-recipes-thelpa-list`
- `straight-recipes-thelpa-version` (optional)

And then to tell Straight.el about the recipe source with

``` emacs-lisp
(straight-use-recipes '(thelpa :type git :host github
                               :repo "thornjad/thelpa"
                               :build nil))
```
