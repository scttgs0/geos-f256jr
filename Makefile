
SYSTEM      ?= atari130
VARIANT     ?= atari
DRIVE       ?= ramdrv_atari
INPUT       ?= joydrv_atari

AS           = ca65
LD           = ld65

ATARI_BANKS ?= 4

ifeq ($(SYSTEM), atari130)
VARIANT      = atari
ATARI_BANKS  = 4
BUILD        = atari_130
RAMDISK_CVT  = ramdisk/cvt-128k
XEX_RESULT   = GEOS_ATARI_130XE.XEX
endif

ifeq ($(SYSTEM), atari320)
VARIANT      = atari
ATARI_BANKS  = 16
BUILD        = atari_320
RAMDISK_CVT  = ramdisk/cvt-320k
XEX_RESULT   = GEOS_ATARI_320K.XEX
endif

ASFLAGS      = -I inc -I .

# Atari port only
ifeq ($(VARIANT), atari)
KERNAL_SOURCES = \
	drv/ramdrv-atari.s \
	input/joydrv_atari_simple.s \
	kernal/start/start_atari.s \
	kernal/bswfont/bswfont.s \
	kernal/hw/displaylist.s \
	kernal/hw/displaylistinit.s \
	kernal/bitmask/bitmask1.s \
	kernal/bitmask/bitmask2.s \
	kernal/bitmask/bitmask3.s \
	kernal/conio/conio1.s \
	kernal/conio/conio2.s \
	kernal/conio/conio3a.s \
	kernal/conio/conio3b.s \
	kernal/conio/conio4.s \
	kernal/conio/conio5.s \
	kernal/conio/conio6.s \
	kernal/dlgbox/dlgbox1a.s \
	kernal/dlgbox/dlgbox1b.s \
	kernal/dlgbox/dlgbox1c.s \
	kernal/dlgbox/dlgbox1d.s \
	kernal/dlgbox/dlgbox1e1.s \
	kernal/dlgbox/dlgbox1e2.s \
	kernal/dlgbox/dlgbox1f.s \
	kernal/dlgbox/dlgbox1g.s \
	kernal/dlgbox/dlgbox1h.s \
	kernal/dlgbox/dlgbox1i.s \
	kernal/dlgbox/dlgbox1j.s \
	kernal/dlgbox/dlgbox1k.s \
	kernal/dlgbox/dlgbox2.s \
	kernal/files/files1a2a.s \
	kernal/files/files1a2b.s \
	kernal/files/files1b.s \
	kernal/files/files2.s \
	kernal/files/files3.s \
	kernal/files/files6a.s \
	kernal/files/files6b.s \
	kernal/files/files6c.s \
	kernal/files/files7.s \
	kernal/files/files8.s \
	kernal/files/files9.s \
	kernal/files/files10.s \
	kernal/fonts/fonts1.s \
	kernal/fonts/fonts2.s \
	kernal/fonts/fonts3.s \
	kernal/fonts/fonts4.s \
	kernal/fonts/fonts4a.s \
	kernal/fonts/fonts4b.s \
	kernal/graph/bitmapclip.s \
	kernal/graph/bitmapup.s \
	kernal/graph/clrscr.s \
	kernal/graph/graphicsstring.s \
	kernal/graph/graph2l1.s \
	kernal/graph/inline.s \
	kernal/graph/inlinefunc.s \
	kernal/start/inlinefuncdebug.s \
	kernal/graph/line.s \
	kernal/graph/pattern.s \
	kernal/graph/point.s \
	kernal/graph/rect.s \
	kernal/graph/scanline.s \
	kernal/header/header.s \
	kernal/hw/hw1b.s \
	kernal/icon/icon1.s \
	kernal/icon/icon2.s \
	kernal/irq/irq.s \
	kernal/init/init1.s \
	kernal/init/init2.s \
	kernal/init/init4.s \
	kernal/jumptab/jumptab-stub.s \
	kernal/keyboard/keyboard1.s \
	kernal/keyboard/keyboard2.s \
	kernal/keyboard/keyboard3.s \
	kernal/load/deskacc.s \
	kernal/load/load1a.s \
	kernal/load/load1b.s \
	kernal/load/load1c.s \
	kernal/load/load2.s \
	kernal/load/load3.s \
	kernal/load/load4b.s \
	kernal/mainloop/mainloop1.s \
	kernal/mainloop/mainloop3.s \
	kernal/math/shl.s \
	kernal/math/shr.s \
	kernal/math/muldiv.s \
	kernal/math/neg.s \
	kernal/math/dec.s \
	kernal/math/random.s \
	kernal/math/crc.s \
	kernal/memory/memory1a.s \
	kernal/memory/memory1b.s \
	kernal/memory/memory2.s \
	kernal/memory/memory3.s \
	kernal/menu/menu1.s \
	kernal/menu/menu2.s \
	kernal/menu/menu3.s \
	kernal/misc/misc.s \
	kernal/mouse/mouse1.s \
	kernal/mouse/mouse2.s \
	kernal/mouse/mouse3.s \
	kernal/mouse/mouse4.s \
	kernal/mouse/mouseptr.s \
	kernal/panic/panic.s \
	kernal/patterns/patterns.s \
	kernal/process/process1.s \
	kernal/process/process2.s \
	kernal/process/process3a.s \
	kernal/process/process3aa.s \
	kernal/process/process3b.s \
	kernal/process/process3c.s \
	kernal/rename.s \
	kernal/ramexp/ramexp1.s \
	kernal/serial/serial1.s \
	kernal/serial/serial2.s \
	kernal/sprites/sprites.s \
	kernal/time/time1.s \
	kernal/tobasic/tobasic2.s \
	kernal/vars/vars.s \
	kernal/hw/banking.s \
	kernal/hw/bank_jmptab_back.s \
	kernal/hw/bank_jmptab_front.s \
	kernal/bitmask/bitmask1b0.s \
	kernal/bitmask/bitmask2b0.s \
	kernal/bitmask/bitmask3b0.s \
	kernal/hw/ramloader.s
endif

DEPS= \
	config.inc \
	inc/c64.inc \
	inc/const.inc \
	inc/diskdrv.inc \
	inc/geosmac.inc \
	inc/geossym.inc \
	inc/inputdrv.inc \
	inc/jumptab.inc \
	inc/kernal.inc \
	inc/printdrv.inc

ifeq ($(VARIANT), atari)
DEPS += \
	inc/atari.inc
endif

ifeq ($(VARIANT), f256jr)
DEPS += \
	inc/f256jr.inc
endif

KERNAL_OBJS=$(KERNAL_SOURCES:.s=.o)
ALL_OBJS=$(KERNAL_OBJS)

BUILD_DIR=build/$(BUILD)

PREFIXED_KERNAL_OBJS = $(addprefix $(BUILD_DIR)/, $(KERNAL_OBJS))

ALL_BINS= \
	$(BUILD_DIR)/kernal/kernal.bin

ifeq ($(VARIANT), atari)
all: $(BUILD_DIR)/$(XEX_RESULT)
else
all: $(BUILD_DIR)/$(D64_RESULT)
endif

clean:
	rm -rf build
	rm -rf kernal/hw/ramloader.s kernal/kernal_*.cfg.out

ifeq ($(VARIANT), atari)
$(BUILD_DIR)/$(XEX_RESULT): $(ALL_BINS)
# no need for processing that bin into xex - all is handled by ld65 config file
	cp $(BUILD_DIR)/kernal/kernal.bin $(BUILD_DIR)/$(XEX_RESULT)
endif

.EXPORT_ALL_VARIABLES:
	export

$(BUILD_DIR)/image00.img:
	chmod +x tools/mkramdisk.py
	tools/mkramdisk.py -n $(ATARI_BANKS) -o $(BUILD_DIR)/image $(RAMDISK_CVT)/*

kernal/hw/ramloader.s: kernal/hw/ramloader.s.in $(BUILD_DIR)/image00.img
	cat $< | gcc -D __ATARI_BANKS=$(ATARI_BANKS) -D __BUILD_DIR=\"$(BUILD_DIR)\" -E - -o - | sed -e 's/^#/;/g' > $@

$(BUILD_DIR)/%.o: %.s
	@mkdir -p `dirname $@`
	$(AS) -D $(VARIANT)=1 -D __ATARI_BANKS=$(ATARI_BANKS) $(ASFLAGS) $< -o $@

kernal/kernal_$(VARIANT).cfg.out: kernal/kernal_$(VARIANT).cfg
	cat $< | sed -e 's/#.*//g' | sed -e 's/^.if/#if/g' | sed -e 's/^.endif/#endif/g' | gcc -D __ATARI_BANKS=$(ATARI_BANKS) -E - -o $@

$(BUILD_DIR)/kernal/kernal.bin: $(PREFIXED_KERNAL_OBJS) kernal/kernal_$(VARIANT).cfg.out
	@mkdir -p $$(dirname $@)
	$(LD) -C kernal/kernal_$(VARIANT).cfg.out $(PREFIXED_KERNAL_OBJS) -o $@ -m $(BUILD_DIR)/kernal/kernal.map -Ln $(BUILD_DIR)/kernal/kernal.lbl

# a must!
love:	
	@echo "Not war, eh?"
