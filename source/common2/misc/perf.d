module misc.perf;


ulong rdtsc()
{
    asm
    {
        rdtsc;
    }
}
