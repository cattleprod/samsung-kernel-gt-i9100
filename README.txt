
< Platform >
1. How to Build 
	- You can use previous platform version.
	Get GT-I9100 open source.
    	: GT-I9100_Opensource.zip 
    	( Download site : http://opensource.samsung.com )

      	Unzip it, then you will see the file GT-I9100_Opensource.zip which includes the Android source code.


< Kernel >
1. How to Build
	- get Toolchain
	Visit http://www.codesourcery.com/, download and install Sourcery G++ Lite 2009q3-68 toolchain for ARM EABI.
	Extract kernel source and move into the top directory.
	$ toolchain\arm-eabi-4.4.0
	$ cd kernel/
	$ make c1_rev02_defconfig
	$ make
	
2. Output files
	- Kernel : kernel/arch/arm/boot/zImage
	
3. How to make .tar binary for downloading into target.
	- change current directory to kernel/arch/arm/boot
	- type following command
	$ tar cvf GT-I9100_Kernel_Gingerbread.tar zImage
