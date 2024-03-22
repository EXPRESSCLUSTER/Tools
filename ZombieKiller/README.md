# Zombie Killer

If a child process has become a zombie and continues to remain for some reason, you can clean it up nicely by instructing the parent process to 'properly see off the child process'. Let's use [zombie-killer.sh](zombie-killer.sh) !

## Required Software

- GNU Debugger (gdb)

## Demo

Before (OMG!)
```
root       1902   1832  0 18:07 ?        00:00:00 parent
root       9579   1902  0 18:08 ?        00:00:00 [children] <defunct>
root      10629   1902  0 18:09 ?        00:00:00 [children] <defunct>
root      11706   1902  0 18:10 ?        00:00:00 [children] <defunct>
```

Execute zombie-killer.
```
# bash zombie-killer.sh
```

After
```
root       1902   1832  0 18:07 ?        00:00:00 parent
```

## Reference

- https://manpages.ubuntu.com/manpages/focal/ja/man2/wait.2.html
- https://ex1.m-yabe.com/archives/3490
