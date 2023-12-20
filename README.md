# ThELPA: Thornjad's Emacs Lisp Package Archive

This repository is my custom ELPA for maximum control. Primarily used to provide package to [Aero Emacs](https://github.com/thornjad/aero).

## Updating the archive

``` sh
make
```

### Build without committing

``` sh
make build
```

## Testing

``` sh
make test
```

## Use the archive from Emacs

### Using package.el

Add ThELPA to your repository list from your configuration, such as in `init.el`:

``` emacs-lisp
(setq package-archives
      `(,@package-archives
        ("thelpa" . "https://thornjad.github.io/thelpa/archive/")))
```

### Using straight.el
