
/*********************************************************/
/*********************************************************/
/*----------------------SDK 3.1.1------------------------*/
/*********************************************************/
/*********************************************************/
#ifdef DEBUG

#define RobotBLELog(fmt, ...) NSLog((@"RobotBLE Log :   %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else

#define RobotBLELog(...)

#endif

/** 蓝牙系统提示框*/
#define ShowBLEAlert NO

//注意：必看！！！
//此处的宽高为板子横向的宽高。
//即
//WIDTH 表示板子长边的像素值
//HEIGHT 表示板子长边的像素值


/**USB P1纵向 宽度**/ //4
#define VALUE_P1_WIDTH  17407.0f
/**USB P1纵向 高度**/
#define VALUE_P1_HEIGHT 10751.0f

/**BLE P7纵向 宽度**/ //1
#define VALUE_P7_WIDTH 14335.0f
/**BLE P7纵向 高度**/
#define VALUE_P7_HEIGHT  8191.0f

/**BLE T7 / T7_TS / T7_LW纵向 宽度**/ //2 / 16 / 17
#define VALUE_T7_WIDTH  14335.0f
/**BLE T7纵向 高度**/
#define VALUE_T7_HEIGHT  8191.0f

/**BLE T7 PLUS纵向 宽度**/ //3 5
#define VALUE_T7P_WIDTH  22015.0f
/**BLE T7 PLUS纵向 高度**/
#define VALUE_T7P_HEIGHT  15359.0f

/**BLE T8A 纵向 宽度**/ // 6
#define VALUE_T8A_WIDTH  22600.0f
/**BLE T8A 纵向 高度**/
#define VALUE_T8A_HEIGHT  16650.0f

/**BLE T7 好写纵向 宽度**/ // 7
#define VALUE_T7_XY_WIDTH  14300.0f
/**BLE T7 好写纵向 高度**/
#define VALUE_T7_XY_HEIGHT  7950.0f

/**BLE T7 PLUS J0 纵向 宽度**/ //8
#define VALUE_J0_A5_WIDTH  14435.0f
/**BLE T7 PLUS J0 纵向 高度**/
#define VALUE_J0_A5_HEIGHT  8191.0f

/**BLE J0_A4 / T9_J0 / J0_A4_P 纵向 宽度**/ //11 / 18 / 19
#define VALUE_J0_A4_WIDTH  22600.0f
/**BLE J0_A4 纵向 高度**/
#define VALUE_J0_A4_HEIGHT  16650.0f


/**BLE T9A 纵向 宽度**/ //12
#define VALUE_T9A_WIDTH  22600.0f
/**BLE T9A 纵向 高度**/
#define VALUE_T9A_HEIGHT  16650.0f

/**BLE X8 纵向 宽度**/ //13
#define VALUE_X8_A5_WIDTH  22100.0f
/**BLE X8 纵向 高度**/
#define VALUE_X8_A5_HEIGHT  14650.0f


//OTA状态
typedef enum {
    /** OTA升级错误*/
    OTA_ERROR,
    /** OTA数据传输*/
    OTA_DATA,
    /** OTA升级*/
    OTA_UPDATE,
    /** OTA成功*/
    OTA_SUCCESS,
    /** 复位*/
    OTA_RESET,
    /** 单个升级成功*/
    OTA_ONE_SUCCESS,
    /** 低电不能升级*/
    OTA_STATUS_ERROR,
    
}OTAState;

//SENSOR状态
typedef enum {
    /** 模组升级错误*/
    SENSOR_ERROR,
    /** 进入模组升级模式*/
    SENSOR_REDAY,
    /** 进入模组升级数据*/
    SENSOR_DATA,
    /** 模组正在升级*/
    SENSOR_UPDATE,
    /** 模组升级成功*/
    SENSOR_SUCCESS,
    /** 模组升级失败*/
    SENSOR_FAIL,
    
}SensorState;


//同步笔记状态
typedef enum {
    /** 同步错误*/
    SYNC_ERROR,
    /** 有未同步笔记*/
    SYNC_NOTE,
    /** 没有未同步笔记*/
    SYNC_NO_NOTE,
    /** 同步成功（一个）*/
    SYNC_SUCCESS,
    /** 开始同步*/
    SYNC_START,
    /** 停止同步*/
    SYNC_STOP,
    /** 同步完成（全部）*/
    SYNC_COMPLETE,
    
}SYNCState;



//设备类型
typedef enum {
    
    UnKnown = 0,
    
    P7  = 1,
    
    T7 = 2,
    
    T7P = 3,
    
    P1 = 4,
    
    T7P_New  =5,
    
    T8A = 6,
    
    T7_XY = 7,
    
    J0_A5 = 8,
    
//    Gateway = 9,
//
//    Dongle = 10,
    
    J0_A4 = 11,
    
    T9A = 12,
    
    X8_A5 = 13,
    
//    T7PL = 14,
//    
//    T7E = 15,
//    
    T7_TS = 16,
    
    T7_LW = 17,
    
    T9_J0 = 18,
    
    J0_A4_P = 19,
    
 
} DeviceType;

//连接状态
typedef enum {
    /**设备已连接（已经存在连接设备）*/
    /**连接设备时候用,防止重复连接*/
    DEVICE_CONNECTED,
    /**正在连接*/
    CONNECTING,
    /**连接成功*/
    CONNECTED,
    /**连接错误*/
    CONNECT_FAIL,
    /**已断开*/
    DISCONNECTED,
    /**服务准备完成*/
    SERVICES_READY,
    /**笔初始化完成*/
    PEN_INIT_COMPLETE,
    /**设备信息获取*/
    DEVICE_INFO_END,
    /**检查设备更新*/
    DEVICE_UPDATE,
    /**检查设备更新失败*/
    DEVICE_UPDATE_FAIL,
    /**设备可更新*/
    DEVICE_UPDATE_CAN,
    /**设备不可更新*/
    DEVICE_UPDATE_CANT,
    /**设备名字修改成功*/
    DEVICE_NAME_UPDATED,
    /**设备名字更新*/
    DEVICE_NAME_UPDATE,
    /**支持频率校准*/
    DEVICE_CALIBRATION_SUPPORT,
    /**不支持频率校准*/
    DEVICE_CALIBRATION_NONSUPPORT,
    /**进入频率校准模式*/
    DEVICE_CALIBRATION_REDAY,
    /**进入频率校准超时*/
    DEVICE_CALIBRATION_OUTTIME,
    /**频率校准成功*/
    DEVICE_CALIBRATION_SUCCESS,
    /**频率校准失败*/
    DEVICE_CALIBRATION_FAIL,
    /**退出频率校准模式*/
    DEVICE_CALIBRATION_QUIT,
    /**支持模组升级*/
    DEVICE_SENSOR_SUPPORT,
    /**不支持模组升级*/
    DEVICE_SENSOR_NONSUPPORT,
    /**模组必须更新,否则无法使用*/
    DEVICE_SENSOR_UPDATE_MUST,
    /**模组不用强制更新*/
    DEVICE_SENSOR_UPDATE_MUSTNOT,
    /**模组可更新*/
    DEVICE_SENSOR_UPDATE_CAN,
    /**模组不可更新*/
    DEVICE_SENSOR_UPDATE_CANT,
    
    
    
}DeviceState;


typedef enum{
    /** 单击*/
    DeviceEvent_CLick = 0,
    /** 双击*/
    DeviceEvent_Double_CLick ,
    /** 向前*/
    DeviceEvent_Front ,
    /** 向后*/
    DeviceEvent_Next ,
    /** 新建页*/
    DeviceEvent_NewPage
}DeviceEventType;



//电磁板电量状态
typedef enum {
    /** 0  */
    Battery_0,
    /** 10 */
    Battery_10,
    /** 20*/
    Battery_20,
    /** 50*/
    Battery_50,
    /** 75*/
    Battery_75,
    /** 85*/
    Battery_85,
    /** 100*/
    Battery_100,
    /** 充电中*/
    Battery_Charge,
    /**充电完成*/
    Battery_Charged,
    
}PercentageBattery;














