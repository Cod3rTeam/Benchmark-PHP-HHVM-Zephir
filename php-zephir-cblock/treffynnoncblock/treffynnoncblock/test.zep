// We are using CBLOCK syntax to directly include a C function in Zephir
// See: https://github.com/phalcon/zephir/pull/21
namespace Treffynnoncblock;

// this is the beginning of the C block
%{

static long mandelbrot (long arg)
{
    long w, h = 0;
    long bit_num = 0;
    char byte_acc = 0;
    long i, iter = 50;
    double x, y, limit = 2.0;
    double Zr, Zi, Cr, Ci, Tr, Ti;

    w = h = arg;

    for(y=0;y<h;++y) 
    {
        for(x=0;x<w;++x)
        {
            Zr = Zi = Tr = Ti = 0.0;
            Cr = (2.0*x/w - 1.5); Ci=(2.0*y/h - 1.0);

            for (i=0;i<iter && (Tr+Ti <= limit*limit);++i)
            {
                Zi = 2.0*Zr*Zi + Ci;
                Zr = Tr - Ti + Cr;
                Tr = Zr * Zr;
                Ti = Zi * Zi;
            }

            byte_acc <<= 1;
            if(Tr+Ti <= limit*limit) byte_acc |= 0x01;

            ++bit_num;

            if(bit_num == 8)
            {
                putc(byte_acc,stdout);
                byte_acc = 0;
                bit_num = 0;
            }
            else if(x == w-1)
            {
                byte_acc <<= (8-w%8);
                putc(byte_acc,stdout);
                byte_acc = 0;
                bit_num = 0;
            }
        }
    }
}

}%
// this is the end of C Block

class Test
{
    public static function treffynnon(long arg) -> string
    {
        // note that this C Block surrounding the call also
        %{
        mandelbrot(arg);
        }%
        return "Complete";
    }
}