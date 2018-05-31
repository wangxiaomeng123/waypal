//
//  ZegoAVApiDefines.h
//  zegoavkit
//
//  Copyright © 2016 Zego. All rights reserved.
//

#ifndef ZegoAVApiDefines_h
#define ZegoAVApiDefines_h


#ifdef __cplusplus
#define ZEGO_EXTERN     extern "C"
#else
#define ZEGO_EXTERN     extern
#endif

ZEGO_EXTERN NSString *const kZegoStreamIDKey;           ///< 流ID，值为 NSString
ZEGO_EXTERN NSString *const kZegoMixStreamIDKey;        ///< 混流ID，值为 NSString
ZEGO_EXTERN NSString *const kZegoRtmpUrlListKey;        ///< rtmp 播放 url 列表，值为 NSArray<NSString *>
ZEGO_EXTERN NSString *const kZegoHlsUrlListKey;         ///< hls 播放 url 列表，值为 NSArray<NSString *>
ZEGO_EXTERN NSString *const kZegoFlvUrlListKey;         ///< flv 播放 url 列表，值为 NSArray<NSString *>

ZEGO_EXTERN NSString *const kZegoDeviceCameraName;      ///< 摄像头设备
ZEGO_EXTERN NSString *const kZegoDeviceMicrophoneName;  ///< 麦克风设备

ZEGO_EXTERN NSString *const kMixStreamAudioOutputFormat; ///< 混流输出格式，值为 NSNumber，可选 {0, 1}
ZEGO_EXTERN NSString *const kPublishCustomTarget;        ///< 自定义转推 rtmp 地址

ZEGO_EXTERN NSString *const kZegoConfigKeepAudioSesionActive;  ///< AudioSession相关配置信息的key, 值为 NSString

typedef unsigned int	uint32;

typedef enum {
    FLAG_RESOLUTION = 0x1,
    FLAG_FPS = 0x2,
    FLAG_BITRATE = 0x4
} SetConfigReturnType;

typedef enum {
    ZegoVideoViewModeScaleAspectFit     = 0,    ///< 等比缩放，可能有黑边
    ZegoVideoViewModeScaleAspectFill    = 1,    ///< 等比缩放填充整View，可能有部分被裁减
    ZegoVideoViewModeScaleToFill        = 2,    ///< 填充整个View
} ZegoVideoViewMode;


typedef enum {
    CAPTURE_ROTATE_0    = 0,
    CAPTURE_ROTATE_90   = 90,
    CAPTURE_ROTATE_180  = 180,
    CAPTURE_ROTATE_270  = 270
} CAPTURE_ROTATE;


typedef enum {
    RemoteViewIndex_First = 0,
    RemoteViewIndex_Second = 1,
    RemoteViewIndex_Third = 2
} RemoteViewIndex;


typedef enum : NSUInteger {
    ZEGO_FILTER_NONE        = 0,    ///< 不使用滤镜
    ZEGO_FILTER_LOMO        = 1,    ///< 简洁
    ZEGO_FILTER_BLACKWHITE  = 2,    ///< 黑白
    ZEGO_FILTER_OLDSTYLE    = 3,    ///< 老化
    ZEGO_FILTER_GOTHIC      = 4,    ///< 哥特
    ZEGO_FILTER_SHARPCOLOR  = 5,    ///< 锐色
    ZEGO_FILTER_FADE        = 6,    ///< 淡雅
    ZEGO_FILTER_WINE        = 7,    ///< 酒红
    ZEGO_FILTER_LIME        = 8,    ///< 青柠
    ZEGO_FILTER_ROMANTIC    = 9,    ///< 浪漫
    ZEGO_FILTER_HALO        = 10,   ///< 光晕
    ZEGO_FILTER_BLUE        = 11,   ///< 蓝调
    ZEGO_FILTER_ILLUSION    = 12,   ///< 梦幻
    ZEGO_FILTER_DARK        = 13    ///< 夜色
} ZegoFilter;

/// \brief 美白特性，
typedef enum : NSUInteger {
    ZEGO_BEAUTIFY_NONE          = 0,        ///< 无美颜
    ZEGO_BEAUTIFY_POLISH        = 1,        ///< 磨皮
    ZEGO_BEAUTIFY_WHITEN        = 1 << 1,   ///< 全屏美白，一般与磨皮结合使用：ZEGO_BEAUTIFY_POLISH | ZEGO_BEAUTIFY_WHITEN
    ZEGO_BEAUTIFY_SKINWHITEN    = 1 << 2,   ///< 皮肤美白
    ZEGO_BEAUTIFY_SHARPEN       = 1 << 3
} ZegoBeautifyFeature;


/// \brief 混流图层信息
@interface ZegoMixStreamInfo : NSObject

@property (copy) NSString *streamID;    ///< 要混流的单流ID
@property int top;
@property int left;
@property int bottom;
@property int right;

/**
 *  原点在左上角，top/bottom/left/right 定义如下：
 *
 *  (left, top)-----------------------
 *  |                                |
 *  |                                |
 *  |                                |
 *  |                                |
 *  -------------------(right, bottom)
 */

@end

enum ZegoAPIVideoEncoderRateControlStrategy
{
    ZEGOAPI_RC_ABR = 0, ///< 恒定码率
    ZEGOAPI_RC_CBR,     ///< 恒定码率
    ZEGOAPI_RC_VBR,     ///< 恒定质量
    ZEGOAPI_RC_CRF,     ///< 恒定质量
};

enum ZegoAPIPublishFlag
{
    ZEGOAPI_JOIN_PUBLISH   = 0 << 0,    ///< 普通连麦
    ZEGOAPI_MIX_STREAM     = 1 << 1,    ///< 混流
    ZEGOAPI_SINGLE_ANCHOR  = 1 << 2,    ///< 单主播场景
};

enum ZegoAPIModuleType
{
    ZEGOAPI_MODULE_AUDIO            = 0x4 | 0x8,    ///< 音频采集播放设备
};

typedef struct
{
    double fps;             ///< 视频帧率
    double kbps;            ///< 视频码率(kb/s)
    double akbps;           ///< 音频码率(kb/s)
    int rtt;                ///< 延时(ms)
    int pktLostRate;        ///< 丢包率(0~255)
    
    int quality;            ///< 质量(0~3)

} ZegoAPIPublishQuality;

typedef ZegoAPIPublishQuality ZegoAPIPlayQuality;

typedef enum : NSUInteger {
    ZEGOAPI_LATENCY_MODE_NORMAL = 0,    ///< 普通延迟模式
    ZEGOAPI_LATENCY_MODE_LOW,           ///< 低延迟模式，*无法用于 RTMP 流*
    ZEGOAPI_LATENCY_MODE_NORMAL2,       ///< 普通延迟模式，最高码率可达192K 
} ZegoAPILatencyMode;

typedef enum : NSUInteger {
    ZEGOAPI_TRAFFIC_NONE = 0,
    ZEGOAPI_TRAFFIC_FPS = 1,
    ZEGOAPI_TRAFFIC_RESOLUTION = 1 << 1,
} ZegoAPITrafficControlProperty;

typedef enum : NSUInteger {
    ZEGOAPI_AUDIO_DEVICE_MODE_COMMUNICATION = 1,    ///< 通话模式, 开启硬件回声消除
    ZEGOAPI_AUDIO_DEVICE_MODE_GENERAL = 2,          ///< 普通模式, 关闭硬件回声消除
    ZEGOAPI_AUDIO_DEVICE_MODE_AUTO = 3              ///< auto模式, 根据场景选择是否开启硬件回声消除
} ZegoAPIAudioDeviceMode;

/** 音频录制时，指定音源类型 */
enum ZegoAPIAudioRecordMask
{
    /** 关闭音频录制 */
    ZEGOAPI_AUDIO_RECORD_NONE      = 0x0,
    /** 打开采集录制 */
    ZEGOAPI_AUDIO_RECORD_CAP       = 0x01,
    /** 打开渲染录制 */
    ZEGOAPI_AUDIO_RECORD_RENDER    = 0x02,
    /** 打开采集和渲染混音结果录制 */
    ZEGOAPI_AUDIO_RECORD_MIX       = 0x04
};

/** 音频录制配置信息 */
typedef struct
{
    /** 启用音频源选择，参考 ZegoAVAPIAudioRecordMask */
    unsigned int mask;
    
    /** 采样率 8000, 16000, 22050, 24000, 32000, 44100, 48000 */
    int sampleRate;
    
    /** 声道数 1(单声道) 或 2(双声道) */
    int channels;
    
} ZegoAPIAudioRecordConfig;

#endif /* ZegoAVApiDefines_h */
