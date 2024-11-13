# K-Start Patrol Remake

## Required Configuration

Before running, you'll need to setup `dosbox`.
Add this lines at the end of your `dosbox` config file:

```
mount C <linux_dir_to_use_as_c_drive>
C:
SET PATH=C:\<path_to_tasm_folder>
cls
```

## How to run
Run `dosbox` and navigate to this projects folder, then run:
```
ASSEMBLE.BAT
```