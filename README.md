#  Raven X2

Random notes and thoughts:

- Move `didBegin` from `GameScene` to some other class that acts as a top-level collision handler
  - This class just uses the bit masks to determine what collisions happened and then calls back to `GameScene`

- Convert OGG to MP3? https://apple.stackexchange.com/questions/26099/is-there-a-way-to-convert-audio-files-in-mac-os-x-or-the-command-line-without-us

- Fix bug with adding / removing components dynamically not working with `EntityManager`
