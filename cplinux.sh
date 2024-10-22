#!/bin/bash
set -e
if [ -z "$1" -o  -z "$2" ]; then
    echo "cplinux source_dir dist_dir"
    exit 1
fi

SOURCE_DIR=$1
DIST_DIR=$2
OLD_KERNEL='linux-4.4.y'
NEW_KERNEL='linux-4.9.329'

cp -f ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/arch/arm/boot/dts/hi37* ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/boot/dts/

cp -f ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/arch/arm/boot/dts/include/dt-bindings/clock/hi37* ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/boot/dts/include/dt-bindings/clock/

cp -f ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/arch/arm/configs/hi37* ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/configs/

cp -Rf ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/arch/arm/mach-hi37* ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/

cp -f ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/arch/arm/Kconfig.hisilicon ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/Kconfig.hisilicon

if [ `grep -c "CONFIG_ARCH_HI3798MX" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/Makefile` -eq '0' ]; then
    sed -i '/# Machine directory name/a\machine-$(CONFIG_ARCH_HI3798MX) += hi3798mx\nmachine-$(CONFIG_ARCH_HI3798CV2X) += hi3798cv2x\nmachine-$(CONFIG_ARCH_HI3798MV2X) += hi3798mv2x\nmachine-$(CONFIG_ARCH_HI3796MV2X) += hi3796mv2x\nmachine-$(CONFIG_ARCH_HI3716MV420N) += hi3716mv420n\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/Makefile
fi

if [ `grep -c "mach-hi3798mx" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/Kconfig` -eq '0' ]; then
    sed -i '/the corresponding mach-\* source/a\source "arch/arm/Kconfig.hisilicon"\nsource "arch/arm/mach-hi3716mv420n/Kconfig"\nsource "arch/arm/mach-hi3798mx/Kconfig"\nsource "arch/arm/mach-hi3798cv2x/Kconfig"\nsource "arch/arm/mach-hi3798mv2x/Kconfig"\nsource "arch/arm/mach-hi3796mv2x/Kconfig"\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/Kconfig
fi

if [ `grep -c "source \"arch\/arm\/Kconfig\.hisilicon\"" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/Kconfig` -eq '0' ]; then
    sed -i '/config ARCH_MULTIPLATFORM/i\source "arch/arm/Kconfig.hisilicon"\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/Kconfig
fi

cp -f ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/drivers/cpufreq/Kconfig.hisilicon ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/cpufreq/Kconfig.hisilicon
if [ `grep -c "drivers\/cpufreq\/Kconfig\\.hisilicon" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/cpufreq/Kconfig` -eq '0' ]; then
    sed -i '/comment "CPU frequency scaling drivers"/a\menu "Hisilicon CPU frequency scaling config"\nsource "drivers\/cpufreq\/Kconfig\.hisilicon"\nendmenu\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/cpufreq/Kconfig
fi

cp -Rf ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/drivers/hisilicon ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/
if [ `grep -c "source "drivers\/hisilicon\/Kconfig"" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/Kconfig` -eq '0' ]; then
    sed -i '/menu "Device Drivers"/a\source "drivers\/hisilicon\/Kconfig"\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/Kconfig
fi

if [ `grep 'CFG_HI_KERNEL_VERSION=linux-4.4.y' -rl ${DIST_DIR}/configs/` ]; then
    sed -i 's/CFG_HI_KERNEL_VERSION=linux-4\.4\.y/CFG_HI_KERNEL_VERSION=linux-4\.9\.329/g' `grep 'CFG_HI_KERNEL_VERSION=linux-4.4.y' -rl ${DIST_DIR}/configs/`
fi

if [ `grep 'CFG_LINUX-4.4.y=y' -rl ${DIST_DIR}/configs/` ]; then
    sed -i 's/CFG_LINUX-4\.4\.y=y/CFG_LINUX-4\.9\.329=y/g' `grep 'CFG_LINUX-4.4.y=y' -rl ${DIST_DIR}/configs/`
fi

sed -i 's/linux-4\.4\.y/linux-4\.9\.329/g' ${DIST_DIR}/source/msp/drv/gpu/utgard/kbuild_flags
sed -i 's/linux-3\.18\.y/linux-4\.9\.329/g' ${DIST_DIR}/source/msp/drv/hdmi/Makefile
sed -i 's/linux-4\.4\.y/linux-4\.9\.329/g' ${DIST_DIR}/.gitignore

sed -i 's/linux-4\.4\.y/linux-4\.9\.329/g' ${DIST_DIR}/scripts/kconfig/Kconfig.kernel
sed -i 's/LINUX-4\.4\.y/LINUX-4\.9\.329/g' ${DIST_DIR}/scripts/kconfig/Kconfig.kernel

if [ `grep -c "\+= hisilicon\/" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/Makefile` -eq '0' ]; then
    sed -i '1i\obj-y \+= hisilicon\/\nifeq ($(CONFIG_MSP),y)\nobj-y \+= common\/\nobj-y \+= msp\/\nendif\nifeq ($(HI_CONFIG_WIFI),y)\nobj-y \+= wifi\/\nendif\nifeq ($(HI_CONFIG_BLUETOOTH),y)\nobj-y \+= bluetooth_usb\/\nendif' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/Makefile
fi

cp -Rf ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/drivers/mtd/hisilicon ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/mtd/
if [ `grep -c "source \"drivers\/mtd\/hisilicon\/Kconfig\"" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/mtd/Kconfig` -eq '0' ]; then
    sed -i '/endif # MTD/i\source "drivers\/mtd\/hisilicon\/Kconfig"\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/mtd/Kconfig
fi
if [ `grep -c "\+= hisilicon\/" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/mtd/Makefile` -eq '0' ]; then
    sed -i '1i\obj-$(CONFIG_MTD_HIFMC100) \+= hisilicon\/\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/mtd/Makefile
fi

cp -Rf ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/include/linux/hisilicon ${DIST_DIR}/source/kernel/${NEW_KERNEL}/include/linux/

cp -Rf ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/drivers/usb/gadget/udc/hiudc ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/usb/gadget/udc/
if [ `grep -c "config USB_HISI_UDC" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/usb/gadget/udc/Kconfig` -eq '0' ]; then
    sed -i '/endmenu/i\config USB_HISI_UDC\n	tristate "Hisilicon USB2.0 Device Controller"\n	depends on HAS_DMA\n	help\n	  Hisilicon Socs include a high speed\n	  USB2.0 Device controller, which can be configured as high speed or\n	  full speed USB peripheral.\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/usb/gadget/udc/Kconfig
fi
if [ `grep -c "CONFIG_USB_HISI_UDC" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/usb/gadget/udc/Makefile` -eq '0' ]; then
    sed -i '1i\ifndef CONFIG_USB_HISI_UDC\nobj-$(CONFIG_USB_GADGET)	\+= udc-core.o\nendif\nobj-$(CONFIG_USB_HISI_UDC)	\+= hiudc\/\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/usb/gadget/udc/Makefile
fi

cp -Rf ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/drivers/net/ethernet/hieth ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/ethernet/
if [ `grep -c "source \"drivers\/net\/ethernet\/hieth\/Kconfig\"" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/ethernet/Kconfig` -eq '0' ]; then
    sed -i '/endif # ETHERNET/i\source "drivers\/net\/ethernet\/hieth\/Kconfig"\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/ethernet/Kconfig
fi
if [ `grep -c "\+= hieth\/" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/ethernet/Makefile` -eq '0' ]; then
    sed -i '1i\obj-$(CONFIG_HIETH_SWITCH_FABRIC) \+= hieth\/\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/ethernet/Makefile
fi
sed -i 's/bus->irq = kmalloc(sizeof(int) \* PHY_MAX_ADDR, GFP_KERNEL);//g' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/ethernet/hieth/mdio.c
sed -i 's/dev->trans_start = jiffies;/netif_trans_update(dev);/g' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/ethernet/hieth/hieth.c
sed -i 's/priv->phy->addr/priv->phy->mdio.addr/g' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/ethernet/hieth/hieth.c

if [ `grep -c "#include <linux\/hisilicon\/cputable\.h>" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/ethernet/hieth/phy.c` -eq '0' ]; then
    sed -i '/#include <linux\/hikapi\.h>/a\#include <linux\/hisilicon\/cputable\.h>\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/ethernet/hieth/phy.c
fi

cp -Rf ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/drivers/net/phy/hisilicon.c ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/phy/
if [ `grep -c "config HISILICON_PHY" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/phy/Kconfig` -eq '0' ]; then
    sed -i '/endif # PHYLIB/i\config HISILICON_PHY\n	tristate "Drivers for HiSilicon PHYs"\n	---help---\n	  Supports the Festa series PHYs.\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/phy/Kconfig
fi
if [ `grep -c "\+= hisilicon\.o" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/phy/Makefile` -eq '0' ]; then
    sed -i '1i\obj-$(CONFIG_HISILICON_PHY)	\+= hisilicon\.o\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/net/phy/Makefile
fi

cp -Rf ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/drivers/mmc/host/himciv200 ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/mmc/host
cp -Rf ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/drivers/mmc/host/himciv300 ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/mmc/host
if [ `grep -c "\+= himciv200\/" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/mmc/host/Makefile` -eq '0' ]; then
    sed -i '1i\obj-$(CONFIG_HIMCIV200_SDIO_SYNOPSYS)  \+= himciv200\/\nobj-$(CONFIG_HIMCIV300_SDIO_SYNOPSYS)  \+= himciv300\/\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/mmc/host/Makefile
fi
sed -i '/if (data->flags & MMC_DATA_STREAM) {/,+2d' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/mmc/host/himciv200/himciv200.c
sed -i '/if (data->flags & MMC_DATA_STREAM) {/,+2d' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/mmc/host/himciv300/himciv300.c

if [ `grep -c "#include <linux\/cpumask\.h>" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/mach-hi3798mx/include/mach/irqs.h` -eq '0' ]; then
    sed -i '/#define __HI_IRQS_H__/a\#include <linux\/cpumask\.h>\n' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/mach-hi3798mx/include/mach/irqs.h
fi

cp -Rf ${SOURCE_DIR}/source/kernel/${OLD_KERNEL}/include/linux/hikapi.h ${DIST_DIR}/source/kernel/${NEW_KERNEL}/include/linux/

if [ `grep -c "orr	r2, r2, r1, LSL #5" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/mach-hi3798mx/headsmp.S` -eq '0' ]; then
    sed -i 's/orr	r2, r1, LSL #5/orr	r2, r2, r1, LSL #5/g' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/arch/arm/mach-hi3798mx/headsmp.S
fi

sed -i 's/-Werror=date-time/-Wno-error=date-time/g' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/Makefile

if [ `grep -c "#include \"clk-hisi\.h\"" ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/hisilicon/clk/hi3798mx/clk-hi3798mv100.c` -ne '0' ]; then
    sed -i 's/#include "clk-hisi\.h"/#include "\.\.\/clk-hisi\.h"/g' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/hisilicon/clk/hi3798mx/clk-hi3798mv100.c
fi
sed -i 's/init.flags = CLK_IS_ROOT | CLK_IS_BASIC | CLK_GET_RATE_NOCACHE;/init.flags = CLK_IS_BASIC | CLK_GET_RATE_NOCACHE;/g' ${DIST_DIR}/source/kernel/${NEW_KERNEL}/drivers/hisilicon/clk/clk-hisi.c

##ion问题##
# # if [ `grep -c "#include "\.\.\/\.\.\/\.\.\/drivers\/staging\/android\/uapi\/ion\.h"" ${DIST_DIR}/source/common/drv/mmz/drv_media_mem.h` -eq '0' ]; then
# #     sed -i 's/#include <linux\/ion\.h>/#include "\.\.\/\.\.\/\.\.\/drivers\/staging\/android\/uapi\/ion\.h"\n#include "\.\.\/\.\.\/\.\.\/drivers\/staging\/android\/ion\/ion\.h"\n/g' ${DIST_DIR}/source/common/drv/mmz/drv_media_mem.h
# # fi

# # if [ `grep -c "int set_buffer_cached(struct ion_client" ${DIST_DIR}/source/common/drv/mmz/drv_mmz_userdev.c` -eq '0' ]; then
# #     sed -i '/HI_DECLARE_MUTEX(process_lock);/i\#include "\.\.\/\.\.\/\.\.\/drivers\/staging\/android\/ion\/ion_priv\.h"\nint set_buffer_cached(struct ion_client \*client, struct ion_handle \*handle,\n							unsigned long flags)\n{\n	struct ion_buffer \*buffer;\n	mutex_lock(&client->lock);\n	if (!ion_handle_validate(client, handle)) {\n		mutex_unlock(&client->lock);\n		return -EINVAL;\n	}\n	buffer = handle->buffer;\n	buffer->flags = flags;\n	mutex_unlock(&client->lock);\n	return 0;\n}\n' ${DIST_DIR}/source/common/drv/mmz/drv_mmz_userdev.c
# # fi

# # if [ `grep -c "struct sg_table \*get_pages_from_buffer(struct ion_client" ${DIST_DIR}/source/common/drv/mmz/drv_media_mem.c` -eq '0' ]; then
# #     sed -i '/LIST_HEAD(mmz_list);/i\#include "\.\.\/\.\.\/\.\.\/drivers\/staging\/android\/ion\/ion_priv\.h"\nstruct sg_table *get_pages_from_buffer(struct ion_client \*client,\n			struct ion_handle \*handle, unsigned long \*size)\n{\n	struct ion_buffer \*buffer;\n	struct sg_table \*table;\n	mutex_lock(&client->lock);\n	if (!ion_handle_validate(client, handle)) {\n		mutex_unlock(&client->lock);\n		return NULL;\n	}\n	buffer = handle->buffer;\n	*size = buffer->size;\n	table = buffer->sg_table;\n	mutex_unlock(&client->lock);\n	return table;\n}\n' ${DIST_DIR}/source/common/drv/mmz/drv_media_mem.c
# # fi

# if [ `grep -c "drv_mmz_ion\.o" ${DIST_DIR}/source/common/drv/Makefile` -eq '0' ]; then
#     sed -i '/mmz\/drv_mmz_userdev\.o/i\$(MOD_NAME_MMZ)-y \+= mmz\/drv_mmz_ion\.o' ${DIST_DIR}/source/common/drv/Makefile
# fi

# if [ `grep -c "#include \"drv_mmz_ion\.h\"" ${DIST_DIR}/source/common/drv/mmz/drv_media_mem.h` -eq '0' ]; then
#     sed -i 's/#include <linux\/ion\.h>/#include "drv_mmz_ion\.h"\n/g' ${DIST_DIR}/source/common/drv/mmz/drv_media_mem.h
# fi

# if [ `grep -c "#include \"drv_mmz_ion\.h\"" ${DIST_DIR}/source/common/drv/mmz/drv_mmz_userdev.c` -eq '0' ]; then
#     sed -i '/#include "hi_drv_dev\.h"/i\#include "drv_mmz_ion\.h"\n' ${DIST_DIR}/source/common/drv/mmz/drv_mmz_userdev.c
# fi
##ion end##
cp ${DIST_DIR}/configs/hi3798mv100/hi3798mdmo1g_hi3798mv100_cfg.mak ${DIST_DIR}/cfg.mak
