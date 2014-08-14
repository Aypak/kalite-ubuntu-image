kalite-ubuntu-image
===================

KA Lite ubuntu image build scripts and assets, including packages for configuring hotspot (auto-started on WiPi dongle insertion), DNS/port redirect (resolving everything to 1.1.1.1, and redirecting port 80 to 8008), and 3G connection start/stop scripts, plus... KA Lite!

Steps:

1. Download [Ubuntu 13.10 x64 desktop image](http://releases.ubuntu.com/saucy/ubuntu-13.10-desktop-amd64.iso).
2. Run ./create-iso.sh
3. Follow prompts to install `uck` as needed.
4. In the popup wizard, select "en" on every page unless you want different languages.
5. Select "Unity" for the desktop environment (not tested with others).
6. In the file selection dialog, choose the Ubuntu ISO file you downloaded in step 1.
7. When it asks if you want to customize the CD manually, say yes.
8. When it asks if you want to delete windows-related files, say no (as desired).
9. Say yes to generating a hybrid image.
10. When it asks for a customization action, select "Run console application"
11. From outside the shell that pops up (a normal terminal, in the "kalite-ubuntu-image" directory), run `sudo cp custom_setup.sh ~/tmp/remaster-root`.
12. From inside the root shell that popped up after step 10, run `./custom_setup.sh`.
13. When it finishes, exit the root shell (CTRL-D or "exit").
14. In the dialog that pops up again, choose "Continue building".
15. After it completes, use UNetBootin (`sudo apt-get install unetbootin`) to write `~/tmp/remaster-new-files/livecd.iso` onto a USB stick and then boot off that USB stick to install onto a computer.
