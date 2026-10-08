# season-dl

Bash script to batch-download a TV season's episodes with wget (resume, retry, colored output).

## Install

```bash
git clone https://github.com/mjasnaashari/season-dl.git
cd season-dl
sudo ln -sf "$PWD/dl.sh" /usr/local/bin/season-dl
```

`/usr/local/bin` is already in `PATH`, so `season-dl` works anywhere.

## Usage

```bash
season-dl 'URL' COUNT
```

- `URL`: link with a `$i` placeholder, or a real link containing `E01`
- `COUNT`: number of episodes (01..COUNT)

Files are saved in the current directory.

```bash
cd ~/Videos/Show/season1
season-dl "https://example.com/Show.S01E01.720p.mkv" 10
```

Use single quotes `'...'` if the URL contains `$i`.

## Options

```
season-dl -h, --help    Show help
```
