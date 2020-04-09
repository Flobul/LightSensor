#include <IOKit/hidsystem/IOHIDEventSystemClient.h>
#include <IOKit/hid/IOHIDEventSystem.h>
#include <Foundation/Foundation.h>
#include <stdio.h>

typedef struct __IOHIDEvent *IOHIDEventRef;
typedef struct __IOHIDServiceClient *IOHIDServiceClientRef;
#ifdef __LP64__
typedef double IOHIDFloat;
#else
typedef float IOHIDFloat;
#endif

IOHIDEventSystemClientRef IOHIDEventSystemClientCreate(CFAllocatorRef allocator);
int IOHIDEventSystemClientSetMatching(IOHIDEventSystemClientRef client, CFDictionaryRef match);
int IOHIDEventSystemClientSetMatchingMultiple(IOHIDEventSystemClientRef client, CFArrayRef match);
IOHIDEventRef IOHIDServiceClientCopyEvent(IOHIDServiceClientRef, int64_t , int32_t, int64_t);
CFStringRef IOHIDServiceClientCopyProperty(IOHIDServiceClientRef service, CFStringRef property);
int IOHIDServiceClientSetProperty(IOHIDServiceClientRef, CFStringRef, CFNumberRef);

static int s_luxMax = 5000;

#define IOHIDEventFieldBase(type)   (type << 16)
#define kIOHIDEventTypeAmbientLightSensor        12

CFArrayRef getValues() {
    int page = 0xff00;
    int usage = 4;
    CFNumberRef nums[2];
    CFStringRef keys[2];
    keys[0] = CFStringCreateWithCString(0, "PrimaryUsagePage", 0);
    keys[1] = CFStringCreateWithCString(0, "PrimaryUsage", 0);
    nums[0] = CFNumberCreate(0, kCFNumberSInt32Type, &page);
    nums[1] = CFNumberCreate(0, kCFNumberSInt32Type, &usage);
    
    CFDictionaryRef dict = CFDictionaryCreate(0, (const void**)keys, (const void**)nums, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    IOHIDEventSystemClientRef system = IOHIDEventSystemClientCreate(kCFAllocatorDefault);
    IOHIDEventSystemClientSetMatching(system, dict);
    CFArrayRef matchingsrvs = IOHIDEventSystemClientCopyServices(system);
    IOHIDServiceClientRef sc = (IOHIDServiceClientRef)CFArrayGetValueAtIndex(matchingsrvs, 0);
    IOHIDEventRef event = IOHIDServiceClientCopyEvent(sc, kIOHIDEventTypeAmbientLightSensor, 0, 0);

    CFNumberRef value;
    int temp = IOHIDEventGetIntegerValue(event, (IOHIDEventField)kIOHIDEventFieldAmbientLightSensorLevel);
    static int luxTotal = 0;
    static int luxNum = 0;
    static int directdaylight = 0;

    value = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &temp);

    luxTotal = temp;
    luxNum = 1;
    int luxValue = ((float)luxTotal)/luxNum;

    if (luxTotal==s_luxMax)
    {
        directdaylight = 1;
    }
    float br = 0.199311f * logf((5000.0f / s_luxMax) * 0.03f * luxValue + 1.0f);
    if (br>1) br = 1;
    float brpc = br * 100;
    
    printf("AmbientLight = %.4f;\nAmbientLightPourcent = %.2f;\nMaxAmbientLight = %4d;\nRAW = %d;\nDayLight = %d;\n",br,brpc,s_luxMax,temp,directdaylight);

    return 0;
}

int main(int argc, const char * argv[]) {

    if (argc!=1)
    {
        printf("Usage: lightsensor \n");
        exit(1);
    }

    printf("\nIOKit Ambient Light Sensor Info >>\n\n");
    printf("\n=> Actual values: \n-------------------------\n");
    getValues();

    return 0;

}
 
