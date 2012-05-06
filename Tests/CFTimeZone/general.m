#include "CoreFoundation/CFBase.h"
#include "CoreFoundation/CFLocale.h"
#include "CoreFoundation/CFTimeZone.h"
#include "Testing.h"
#include "../CFTesting.h"

int main (void)
{
  CFTimeZoneRef tz;
  CFStringRef str;
  CFLocaleRef loc;
  CFDictionaryRef dict;
  CFDictionaryRef abbrevDump;
  CFAbsoluteTime at;
  CFTimeInterval ti;
  
  /* FIXME: Need CFTimeZoneCopyAbbreviationDictionary
  tz = CFTimeZoneCreateWithName (NULL, CFSTR("CST"), false);
  PASS(tz == NULL,
       "Time zone named 'CST' is not found if abbreviations are not searched.");
  tz = CFTimeZoneCreateWithName (NULL, CFSTR("CST"), true);
  PASS(tz != NULL,
       "Time zone named 'CST' was found when abbreviations were searched");
  str = CFTimeZoneGetName (tz);
  PASS_CFEQ(str, CFSTR("US/Central"), "Time zone name is 'US/Central'");
  
  CFRelease (tz);*/
  
  tz = CFTimeZoneCreateWithName (NULL, CFSTR("Europe/Rome"), false);
  str = CFTimeZoneGetName (tz);
  PASS_CFEQ(str, CFSTR("Europe/Rome"), "'Europe/Rome' time zone created.");
  
  at = CFTimeZoneGetSecondsFromGMT (tz, 1000000.0);
  PASS(at == 7200.0,
       "Offset from GMT at 1000000 seconds from absolute epoch is '%f'", at);
  PASS(CFTimeZoneIsDaylightSavingTime (tz, 1000000.0) == true,
       "On daylight saving time at 1000000 seconds from absolute epoch.");
  
  loc = CFLocaleCreate (NULL, CFSTR("en_GB"));
  
  str = CFTimeZoneCopyLocalizedName (tz, kCFTimeZoneNameStyleStandard, loc);
  PASS_CFEQ(str, CFSTR("Central European Time"),
            "Standard localized name is correct.");
  CFRelease (str);
  
  str = CFTimeZoneCopyLocalizedName (tz, kCFTimeZoneNameStyleShortStandard, loc);
  PASS_CFEQ(str, CFSTR("CET"), "Short standard localized name is correct.");
  CFRelease (str);
  
  CFRelease (loc);
  
  ti = CFTimeZoneGetDaylightSavingTimeOffset (tz, 0.0);
  PASS(ti == 3600.0,
       "Daylight Saving time offset at 0 second from absolute epoch is '%f'.", ti);
  
  at = CFTimeZoneGetNextDaylightSavingTimeTransition (tz, 1000000.0);
  PASS(at == 45874800.0, "Next daylight saving transition is at '%f'.", at);
  
  CFRelease (tz);
  
  dict = CFDictionaryCreateMutable (NULL, 0,
                                    &kCFCopyStringDictionaryKeyCallBacks,
                                    &kCFTypeDictionaryValueCallBacks);
  abbrevDump = CFTimeZoneCopyAbbreviationDictionary();
  if (abbrevDump)
    {
      PASS_CFEQ(abbrevDump, dict, "Dump abbreviation dictionary.");
      CFRelease (abbrevDump);
    }
  CFRelease (dict);
  
  return 0;
}