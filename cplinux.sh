#!/bin/bash
cp -f ./HiSTBLinuxV100R005C00SPC050/source/kernel/linux-4.4.y/arch/arm/boot/dts/hi37* ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/arch/arm/boot/dts/

cp -f ./HiSTBLinuxV100R005C00SPC050/source/kernel/linux-4.4.y/arch/arm/boot/dts/include/dt-bindings/clock/hi37* ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/arch/arm/boot/dts/include/dt-bindings/clock/

cp -f ./HiSTBLinuxV100R005C00SPC050/source/kernel/linux-4.4.y/arch/arm/configs/hi37* ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/arch/arm/configs/

cp -Rf ./HiSTBLinuxV100R005C00SPC050/source/kernel/linux-4.4.y/arch/arm/mach-hi37* ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/arch/arm/

cp -f ./HiSTBLinuxV100R005C00SPC050/source/kernel/linux-4.4.y/arch/arm/Kconfig.hisilicon ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/arch/arm/Kconfig.hisilicon

if [ `grep -c "CONFIG_ARCH_HI3798MX" ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/arch/arm/Makefile` -eq '0' ]; then
    sed -i '/# Machine directory name/a\machine-$(CONFIG_ARCH_HI3798MX) += hi3798mx\nmachine-$(CONFIG_ARCH_HI3798CV2X) += hi3798cv2x\nmachine-$(CONFIG_ARCH_HI3798MV2X) += hi3798mv2x\nmachine-$(CONFIG_ARCH_HI3796MV2X) += hi3796mv2x\nmachine-$(CONFIG_ARCH_HI3716MV420N) += hi3716mv420n\n' ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/arch/arm/Makefile
fi

if [ `grep -c "mach-hi3798mx" ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/arch/arm/Kconfig` -eq '0' ]; then
    sed -i '/the corresponding mach-\* source/a\source "arch/arm/Kconfig.hisilicon"\nsource "arch/arm/mach-hi3716mv420n/Kconfig"\nsource "arch/arm/mach-hi3798mx/Kconfig"\nsource "arch/arm/mach-hi3798cv2x/Kconfig"\nsource "arch/arm/mach-hi3798mv2x/Kconfig"\nsource "arch/arm/mach-hi3796mv2x/Kconfig"\n' ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/arch/arm/Kconfig
fi

if [ `grep -c "source \"arch\/arm\/Kconfig\.hisilicon\"" ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/arch/arm/Kconfig` -eq '0' ]; then
    sed -i '/config ARCH_MULTIPLATFORM/i\source "arch/arm/Kconfig.hisilicon"\n' ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/arch/arm/Kconfig
fi

cp -f ./HiSTBLinuxV100R005C00SPC050/source/kernel/linux-4.4.y/drivers/cpufreq/Kconfig.hisilicon ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/drivers/cpufreq/Kconfig.hisilicon
if [ `grep -c "drivers\/cpufreq\/Kconfig\\.hisilicon" ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/drivers/cpufreq/Kconfig` -eq '0' ]; then
    sed -i '/comment "CPU frequency scaling drivers"/a\menu "Hisilicon CPU frequency scaling config"\nsource "drivers\/cpufreq\/Kconfig\.hisilicon"\nendmenu\n' ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/drivers/cpufreq/Kconfig
fi

cp -Rf ./HiSTBLinuxV100R005C00SPC050/source/kernel/linux-4.4.y/drivers/hisilicon ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/drivers/
if [ `grep -c "source "drivers\/hisilicon\/Kconfig"" ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/drivers/Kconfig` -eq '0' ]; then
    sed -i '/menu "Device Drivers"/a\source "drivers\/hisilicon\/Kconfig"\n' ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/drivers/Kconfig
fi

if [ `grep 'CFG_HI_KERNEL_VERSION=linux-4.4.y' -rl ./HiSTBLinuxV100R005C00SPC050_n/configs/` ]; then
    sed -i 's/CFG_HI_KERNEL_VERSION=linux-4\.4\.y/CFG_HI_KERNEL_VERSION=linux-4\.9\.329/g' `grep 'CFG_HI_KERNEL_VERSION=linux-4.4.y' -rl ./HiSTBLinuxV100R005C00SPC050_n/configs/`
fi

if [ `grep 'CFG_LINUX-4.4.y=y' -rl ./HiSTBLinuxV100R005C00SPC050_n/configs/` ]; then
    sed -i 's/CFG_LINUX-4\.4\.y=y/CFG_LINUX-4\.9\.329=y/g' `grep 'CFG_LINUX-4.4.y=y' -rl ./HiSTBLinuxV100R005C00SPC050_n/configs/`
fi

sed -i 's/linux-4\.4\.y/linux-4\.9\.329/g' ./HiSTBLinuxV100R005C00SPC050_n/source/msp/drv/gpu/utgard/kbuild_flags
sed -i 's/linux-3\.18\.y/linux-4\.9\.329/g' ./HiSTBLinuxV100R005C00SPC050_n/source/msp/drv/hdmi/Makefile
sed -i 's/linux-4\.4\.y/linux-4\.9\.329/g' ./HiSTBLinuxV100R005C00SPC050_n/.gitignore

sed -i 's/linux-4\.4\.y/linux-4\.9\.329/g' ./HiSTBLinuxV100R005C00SPC050_n/scripts/kconfig/Kconfig.kernel
sed -i 's/LINUX-4\.4\.y/LINUX-4\.9\.329/g' ./HiSTBLinuxV100R005C00SPC050_n/scripts/kconfig/Kconfig.kernel

if [ `grep -c "\+= hisilicon\/" ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/drivers/Makefile` -eq '0' ]; then
    sed -i '1i/obj-y \+= hisilicon\/\nifeq ($(CONFIG_MSP),y)\nobj-y \+= common\/\nobj-y \+= msp\/\nendif\nifeq ($(HI_CONFIG_WIFI),y)\nobj-y \+= wifi\/\nendif\nifeq ($(HI_CONFIG_BLUETOOTH),y)\nobj-y \+= bluetooth_usb\/\nendif' ./HiSTBLinuxV100R005C00SPC050_n/source/kernel/linux-4.9.329/drivers/Makefile
fi

cp ./HiSTBLinuxV100R005C00SPC050_n/configs/hi3798mv100/hi3798mdmo1g_hi3798mv100_cfg.mak ./HiSTBLinuxV100R005C00SPC050_n/cfg.mak
