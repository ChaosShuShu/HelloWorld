# LOG sys
```cpp 
//from x265
#define  x265_log(param, ...) general_log(param, "x265", __VA_ARGS__)

void general_log(const x265_param* param, const char* caller, int level, const char* fmt, ...)
{
    if (param && level > param->logLevel)
        return;
    const int bufferSize = 4096;
    char buffer[bufferSize];
    int p = 0;
    const char* log_level;
    switch (level)
    {
    case X265_LOG_ERROR:
        log_level = "error";
        break;
    case X265_LOG_WARNING:
        log_level = "warning";
        break;
    case X265_LOG_INFO:
        log_level = "info";
        break;
    case X265_LOG_DEBUG:
        log_level = "debug";
        break;
    case X265_LOG_FULL:
        log_level = "full";
        break;
    default:
        log_level = "unknown";
        break;
    }
    
    if (caller)
        p += sprintf(buffer, "%-4s [%s]: ", caller, log_level);
    va_list arg;
    va_start(arg, fmt);
    vsnprintf(buffer + p, bufferSize - p, fmt, arg);
    va_end(arg);
    fputs(buffer, stderr);
}
```