//
//  Common.h
//  DreamVoice
//
//  Created by Leon on 10/2/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#ifndef DreamVoice_Common_h
#define DreamVoice_Common_h

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define DVSEGUEIDENTIFIERLOGIN @"DVSegueIdenifierLogin"
#define DVSEGUEIDENTIFIERADDNEWVOICE @"DVSegureIdentifierAddNewVoice"

#endif
