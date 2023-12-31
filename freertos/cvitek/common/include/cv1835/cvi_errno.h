/*
 * Copyright (C) Cvitek Co., Ltd. 2019-2020. All rights reserved.
 *
 * File Name: include/cvi_errno.h
 * Description:
 *   error code definition.
 */

#ifndef __CVI_ERRNO_H__
#define __CVI_ERRNO_H__

#include "cvi_debug.h"

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif /* End of #ifdef __cplusplus */


#ifndef CVI_ERR_APPID
#define CVI_ERR_APPID  (0x00000000L)
#endif

typedef enum _ERR_LEVEL_E {
	EN_ERR_LEVEL_DEBUG = 0,  /* debug-level                                  */
	EN_ERR_LEVEL_INFO,       /* informational                                */
	EN_ERR_LEVEL_NOTICE,     /* normal but significant condition             */
	EN_ERR_LEVEL_WARNING,    /* warning conditions                           */
	EN_ERR_LEVEL_ERROR,      /* error conditions                             */
	EN_ERR_LEVEL_CRIT,       /* critical conditions                          */
	EN_ERR_LEVEL_ALERT,      /* action must be taken immediately             */
	EN_ERR_LEVEL_FATAL,      /* just for compatibility with previous version */
	EN_ERR_LEVEL_BUTT
} ERR_LEVEL_E;


/******************************************************************************	*/
/*|----------------------------------------------------------------|*/
/*| 11|   APP_ID   |   MOD_ID    | ERR_LEVEL |   ERR_ID            |*/
/*|----------------------------------------------------------------|*/
/*|<--><--6bits----><----8bits---><--3bits---><------13bits------->|*/
/*******************************************************************************/

#define CVI_DEF_ERR(module, level, errid) \
	((CVI_S32)(0xC0000000L | (CVI_ERR_APPID) | ((module) << 16) | ((level)<<13) | (errid)))

/* NOTE! the following defined all common error code,		*/
/*** all module must reserved 0~63 for their common error code*/

typedef enum _EN_ERR_CODE_E {
	EN_ERR_INVALID_DEVID = 1, /* invalid device ID */
	EN_ERR_INVALID_CHNID = 2, /* invalid channel ID*/
	EN_ERR_ILLEGAL_PARAM = 3,
	/* at least one parameter is illegal*/
	/* eg, an illegal enumeration value */
	EN_ERR_EXIST         = 4, /* resource exists*/
	EN_ERR_UNEXIST       = 5, /* resource unexists */
	EN_ERR_NULL_PTR      = 6, /* using a NULL point*/
	EN_ERR_NOT_CONFIG    = 7,
	/* try to enable or initialize system, device*/
	/* or channel, before configing attribute*/
	EN_ERR_NOT_SUPPORT   = 8,
	/* operation or type is not supported by NOW*/
	EN_ERR_NOT_PERM      = 9,
	/* operation is not permitted*/
	/* eg, try to change static attribute*/
	EN_ERR_INVALID_PIPEID = 10,
	/* invalid pipe ID*/
	EN_ERR_INVALID_GRPID  = 11,
	/* invalid group ID*/
	EN_ERR_NOMEM         = 12,
	/* failure caused by malloc memory*/
	EN_ERR_NOBUF         = 13,
	/* failure caused by malloc buffer*/
	EN_ERR_BUF_EMPTY     = 14,
	/* no data in buffer */
	EN_ERR_BUF_FULL      = 15,
	/* no buffer for new data*/
	EN_ERR_SYS_NOTREADY  = 16,
	/* System is not ready, maybe not initialized or*/
	/* loaded. Returning the error code when opening*/
	/* a device file failed.*/
	EN_ERR_BADADDR       = 17,
	/* bad address,*/
	/* eg. used for copy_from_user & copy_to_user*/
	EN_ERR_BUSY          = 18,
	/* resource is busy,*/
	/* eg. destroy a venc chn without unregister it */
	EN_ERR_SIZE_NOT_ENOUGH = 19,
	/* buffer size is smaller than the actual size required */
	EN_ERR_INVALID_VB    = 20,
	/* invalid VB handle */
	EN_ERR_BUTT          = 63,
	/* maximum code, private error code of all modules*/
	/* must be greater than it */
} EN_ERR_CODE_E;



#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif /* __cplusplus */

#endif  /* __CVI_ERRNO_H__ */

