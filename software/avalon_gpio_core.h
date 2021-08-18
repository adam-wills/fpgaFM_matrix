#include "alt_types.h"
#include "io.h"

// macros
/* rd/wr PIO data reg */
#define pio_read(base)         IORD(base, PIO_DATA_REG_OFT)
#define pio_write(base, data)  IOWR(base, PIO_DATA_REG_OFT, data)
/* rd/clr pushbutton edge capture reg */
/* must write 0xf if the write-individual-bit option is used in SOPC */
#define btn_read(base)         IORD(base, PIO_EDGE_REG_OFT)
#define btn_clear(base)        IOWR(base, PIO_EDGE_REG_OFT, 0xf)
#define btn_is_pressed(base)   (IORD(base, PIO_EDGE_REG_OFT) != 0)

class GpoCore {
  /* register map */
  enum {
    DATA_REG = 0,// data register
    DIRC_REG = 1,// direction register
    INTM_REG = 2,// interrupt mask register
    EDGE_REG = 3 // edge-capture register
  };
public:
  GpoCore(uint32_t core_base_addr);  // constructor
  ~GpoCore();
  /* methods */
  void write(uint32_t data);              // write 32-bit word
  void write(int bit_value, int bit_pos); // write single bit
private:
  uint32_t base_addr;
  uint32_t wr_data;
};

class GpiCore {
  /* register map */
  enum {
    DATA_REG = 0 // data register
  };
public:
  GpiCore(uint32_t core_base_addr);
  ~GpiCore();
  /* methods */
  uint32_t read();
  int read(int bit_pos);
private:
  uint32_t base_addr;
};
