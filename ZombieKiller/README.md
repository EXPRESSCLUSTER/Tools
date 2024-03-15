# Zombie Killer

If a child process has become a zombie and continues to remain for some reason, you can clean it up nicely by instructing the parent process to 'properly see off the child process'. Let's use [zombie-killer.sh](zombie-killer.sh) !

Before (OMG!)
```
root       1902   1832  0 18:07 ?        00:00:00 parent
root       9579   1902  0 18:08 ?        00:00:00 [children] <defunct>
root      10629   1902  0 18:09 ?        00:00:00 [children] <defunct>
root      11706   1902  0 18:10 ?        00:00:00 [children] <defunct>
```

After
```
root       1902   1832  0 18:07 ?        00:00:00 parent
```
