let _rt = loadRuntime();

// 待办事项：
// Video的事件监听是否可以调用多次？并且取消事件监听传指定listener的话是否是只移除该listener？offXXX传null时是否是移除该类型下的所有listener？
// 确认上述事情之后在_VideoProxy当中监听所有事件，并且通过customCommand的方法传给原生层

if (_rt.Video && _rt.createVideo !== undefined) {

    var _videoInstanceRegistry = {};

    const _videosWeakMap = new WeakMap();

    let createVideo = _rt.createVideo;
    delete _rt.createVideo;

    var _VideoProxy = function _VideoProxy(obj) {
        let videoProxy = this;
        if (typeof obj !== "object") {
            console.error("create video with a invalid object!");
            return;
        }

        let video = createVideo();
        this.video = video;

        obj.autoplay = true;
        console.log("创建视频，seek:" + video.seek);

        _videosWeakMap.set(video, {
            _x: 0,
            _y: 0,
            _width: 0,
            _height: 0,
            _underGameView: false,
            _objectFit: "contain",
            _backgroundColor: "#000000",
        });
        if (typeof obj.x === "number") {
            video.x = Math.floor(obj.x);
        } else {
            video.x = 0;
            console.warn("create video with a invalid argument!use default value!");
        }
        if (typeof obj.y === "number") {
            video.y = Math.floor(obj.y);
        } else {
            video.y = 0;
            console.warn("create video with a invalid argument!use default value!");
        }
        if (typeof obj.width === "number") {
            video.width = Math.floor(obj.width);
        } else {
            video.width = 0;
            console.warn("create video with a invalid argument!use default value!");
        }
        if (typeof obj.height === "number") {
            video.height = Math.floor(obj.height);
        } else {
            video.height = 0;
            console.warn("create video with a invalid argument!use default value!");
        }
        if ((typeof obj.underGameView === "boolean" || obj.underGameView === null)) {
            video.underGameView = obj.underGameView;
        } else {
            video.underGameView = false;
            console.warn("create video with a invalid argument!use default value!");
        }
        if ((obj.objectFit === "fill" || obj.objectFit === "contain" || obj.objectFit === "cover")) {
            video.objectFit = obj.objectFit;
        } else {
            video.objectFit = "contain";
            console.warn("create video with a invalid argument!use default value!");
        }
        if (typeof obj.backgroundColor === "string" && obj.backgroundColor.length == 7) {
            video.backgroundColor = obj.backgroundColor;
        } else {
            video.backgroundColor = "#000000";
            console.warn("create video with a invalid argument!use default value!");
        }

        video.autoplay = obj.autoplay;
        video.currentTime = obj.initialTime;
        video.defaultPlaybackRate = obj.playbackRate;
        video.live = obj.live;
        video.loop = obj.loop;
        video.muted = obj.muted;
        video.obeyMuteSwitch = obj.obeyMuteSwitch;
        video.preload = 'auto';
        video.src = obj.src;
        video.volume = 1;

        _videoInstanceRegistry[video.instanceID] = video;

        // 注册监听视频播放中断事件
        video.onAbort(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onAbort", video.instanceID);
        });

        // 注册监听视频能被播放事件, 在 currentTime 指定的播放位置上
        video.onCanplay(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onCanplay", video.instanceID);
        });

        // 注册监听视频时长变化事件, 当 duration 发生变化时触发
        video.onDurationChange(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onDurationChange", video.instanceID);
        });

        // 注册监听视频播放结束事件
        video.onEnded(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onEnded", video.instanceID);
        });

        // 注册监听 Video 错误事件
        video.onError(function (res) {
            let code = -1;
            let message = "error";
            if (res && res.code) {
                code = res.code;
            }
            if (res && res.message) {
                message = res.message;
            }
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onError", video.instanceID, code, message);
        });

        // 注册监听视频第一帧数据被加载事件
        video.onLoadedData(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onLoadedData", video.instanceID);
        });

        // 注册监听 metadata 内容已被加载事件
        video.onLoadedMetadata(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onLoadedMetadata", video.instanceID);
        });

        // 注册监听开始加载视频内容事件
        video.onLoadStart(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onLoadStart", video.instanceID);
        });

        // 注册监听视频暂停事件, 当属性 paused 变为 true 时触发
        video.onPause(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onPause", video.instanceID);
        });

        // 注册监听视频正在播放事件, 事件在播放准备开始时（之前被暂停或者由于数据缺乏被暂缓）被触发
        video.onPlay(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onPlay", video.instanceID);
        });

        // 注册监听视频正在播放事件, 事件在播放准备开始时（之前被暂停或者由于数据缺乏被暂缓）被触发
        video.onPlaying(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onPlaying", video.instanceID);
        });

        // 注册监听视频内容加载进度事件
        // Object res
        // res.bufferedTime 当前缓冲时间, 单位为秒 
        // res.duration 视频的总时长, 单位为秒
        video.onProgress(function (res) {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onProgress", video.instanceID, res.bufferedTime, res.duration);
        });

        // 注册监听视频播放速率变化事件, 当 playbackRate 发生变化时触发
        video.onRateChange(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onRateChange", video.instanceID);
        });

        // 注册监听视频固有尺寸变化事件, 当 videoWidth、videoHeight 任意一个属性发生变化时触发
        video.onResize(function () {
            switch (this.objectFit) {
                case "fill":
                case "contain":
                case "cover":
                    break;
                default:
                    console.warn("set property objectFit with a invalid value!");
                    return;
            }
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onResize", this.instanceID, this.videoWidth, this.videoHeight, this.objectFit, this.width, this.height);
        });

        // 注册监听视频播放跳转完成事件, 当 seek 操作结束时触发
        video.onSeeked(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onSeeked", video.instanceID);
        });

        // 注册监听视频播放跳转事件, 当 seek 操作开始时触发
        video.onSeeking(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onSeeking", video.instanceID);
        });

        // 注册监听视频播放进度更新事件
        // Object res
        // res.currentTime 当前的播放位置, 单位为秒
        // res.duration 视频的总时长, 单位为秒
        video.onTimeUpdate(function (res) {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onTimeUpdate", video.instanceID, res.currentTime, res.duration);
        });

        // 注册监听视频音量变化事件, 当 volume 发生变化时触发
        video.onVolumeChange(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onVolumeChange", video.instanceID);
        });

        // 注册监听视频播放等待事件, 当加载的视频内容不足以播放导致播放暂停时触发
        video.onWaiting(function () {
            _rt.callCustomCommand({
                success: function (res) { },
                fail: function (res) { }
            }, "sud-video-onWaiting", video.instanceID);
        });

        _rt.callCustomCommand({
            success: function (res) { },
            fail: function (res) { }
        }, "sud-video-create", video.instanceID, video.x, video.y, video.width, video.height, obj.src, obj.poster,
            obj.initialTime, obj.playbackRate, obj.live, video.objectFit, obj.controls, obj.showProgress, obj.showProgressInControlMode, video.backgroundColor,
            obj.autoplay, obj.loop, obj.muted, obj.obeyMuteSwitch, obj.enableProgressGesture, obj.enablePlayGesture, obj.showCenterPlayBtn, video.underGameView,
            obj.autoPauseIfNavigate, obj.autoPauseIfOpenNative);
    }

    // begin 事件类型的传递
    _VideoProxy.prototype.offAbort = function (listener) {
        this.video.offAbort(listener);
    };
    _VideoProxy.prototype.offCanplay = function (listener) {
        this.video.offCanplay(listener);
    };
    _VideoProxy.prototype.offDuratioffChange = function (listener) {
        this.video.offDuratioffChange(listener);
    };
    _VideoProxy.prototype.offEnded = function (listener) {
        this.video.offEnded(listener);
    };
    _VideoProxy.prototype.offError = function (listener) {
        this.video.offError(listener);
    };
    _VideoProxy.prototype.offLoadedData = function (listener) {
        this.video.offLoadedData(listener);
    };
    _VideoProxy.prototype.offLoadedMetadata = function (listener) {
        this.video.offLoadedMetadata(listener);
    };
    _VideoProxy.prototype.offLoadStart = function (listener) {
        this.video.offLoadStart(listener);
    };
    _VideoProxy.prototype.offPause = function (listener) {
        this.video.offPause(listener);
    };
    _VideoProxy.prototype.offPlay = function (listener) {
        this.video.offPlay(listener);
    };
    _VideoProxy.prototype.offPlaying = function (listener) {
        this.video.offPlaying(listener);
    };
    _VideoProxy.prototype.offProgress = function (listener) {
        this.video.offProgress(listener);
    };
    _VideoProxy.prototype.offRateChange = function (listener) {
        this.video.offRateChange(listener);
    };
    _VideoProxy.prototype.offResize = function (listener) {
        this.video.offResize(listener);
    };
    _VideoProxy.prototype.offSeeked = function (listener) {
        this.video.offSeeked(listener);
    };
    _VideoProxy.prototype.offSeeking = function (listener) {
        this.video.offSeeking(listener);
    };
    _VideoProxy.prototype.offTimeUpdate = function (listener) {
        this.video.offTimeUpdate(listener);
    };
    _VideoProxy.prototype.offVolumeChange = function (listener) {
        this.video.offVolumeChange(listener);
    };
    _VideoProxy.prototype.offWaiting = function (listener) {
        this.video.offWaiting(listener);
    };

    _VideoProxy.prototype.onAbort = function (listener) {
        this.video.onAbort(listener);
    };
    _VideoProxy.prototype.onCanplay = function (listener) {
        this.video.onCanplay(listener);
    };
    _VideoProxy.prototype.onDurationChange = function (listener) {
        this.video.onDurationChange(listener);
    };
    _VideoProxy.prototype.onEnded = function (listener) {
        this.video.onEnded(listener);
    };
    _VideoProxy.prototype.onError = function (listener) {
        this.video.onError(listener);
    };
    _VideoProxy.prototype.onLoadedData = function (listener) {
        this.video.onLoadedData(listener);
    };
    _VideoProxy.prototype.onLoadedMetadata = function (listener) {
        this.video.onLoadedMetadata(listener);
    };
    _VideoProxy.prototype.onLoadStart = function (listener) {
        this.video.onLoadStart(listener);
    };
    _VideoProxy.prototype.onPause = function (listener) {
        this.video.onPause(listener);
    };
    _VideoProxy.prototype.onPlay = function (listener) {
        this.video.onPlay(listener);
    };
    _VideoProxy.prototype.onPlaying = function (listener) {
        this.video.onPlaying(listener);
    };
    _VideoProxy.prototype.onProgress = function (listener) {
        this.video.onProgress(listener);
    };
    _VideoProxy.prototype.onRateChange = function (listener) {
        this.video.onRateChange(listener);
    };
    _VideoProxy.prototype.onResize = function (listener) {
        this.video.onResize(listener);
    };
    _VideoProxy.prototype.onSeeked = function (listener) {
        this.video.onSeeked(listener);
    };
    _VideoProxy.prototype.onSeeking = function (listener) {
        this.video.onSeeking(listener);
    };
    _VideoProxy.prototype.onTimeUpdate = function (listener) {
        this.video.onTimeUpdate(listener);
    };
    _VideoProxy.prototype.onVolumeChange = function (listener) {
        this.video.onVolumeChange(listener);
    };
    _VideoProxy.prototype.onWaiting = function (listener) {
        this.video.onWaiting(listener);
    };

    // end 事件类型的传递

    // start 方法传递
    _VideoProxy.prototype.destroy = function () {
        this.video.destroy();
    };
    _VideoProxy.prototype.pause = function () {
        let video = this.video;
        return new Promise((resolve, reject) => {
            video.pause({
                success(res) {
                    resolve(res);
                },
                fail(err) {
                    reject(err);
                },
                complete(res) {
                    // Promise 用 finally 处理
                }
            });
        });
    };
    _VideoProxy.prototype.play = function () {
        let video = this.video;
        return new Promise((resolve, reject) => {
            video.play({
                success(res) {
                    resolve(res);
                },
                fail(err) {
                    reject(err);
                },
                complete(res) {
                    // Promise 用 finally 处理
                }
            });
        });
    };
    _VideoProxy.prototype.seek = function (time) {
        let video = this.video;
        video.currentTime = time;
        return new Promise((resolve, reject) => {
            resolve({ time: video.currentTime });
        });
    };
    _VideoProxy.prototype.stop = function () {
        let video = this.video;
        return new Promise((resolve, reject) => {
            video.stop({
                success(res) {
                    resolve(res);
                },
                fail(err) {
                    reject(err);
                },
                complete(res) {
                    // Promise 用 finally 处理
                }
            });
        });
    };
    // 设置全屏时视频的方向
    // 0 正常竖向
    // 90 屏幕逆时针90度
    // -90 屏幕顺时针90度
    _VideoProxy.prototype.requestFullScreen = function (direction) {
        let video = this.video;
        return new Promise((resolve, reject) => {
            let result = _rt.callCustomCommandSync("sud-video-requestFullScreen", video.instanceID, direction);
            if (result && result.error) {
                reject(err);
            } else {
                resolve();
            }
        });
    };
    // 设置全屏时视频的方向
    // 0 正常竖向
    // 90 屏幕逆时针90度
    // -90 屏幕顺时针90度
    _VideoProxy.prototype.exitFullScreen = function () {
        let video = this.video;
        return new Promise((resolve, reject) => {
            let result = _rt.callCustomCommandSync("sud-video-exitFullScreen", video.instanceID);
            if (result && result.error) {
                reject(err);
            } else {
                resolve();
            }
        });
    };
    // end 方法传递

    //参考wx小游戏平台createvideo的object参数属性
    //https://developers.weixin.qq.com/minigame/dev/api/media/video/wx.createVideo.html
    _rt.createVideo = function (obj) {
        return new _VideoProxy(obj);
    };

    /*
    添加Video的坐标和宽高属性
    */
    Object.defineProperty(_rt.Video.prototype, "x", {
        configurable: false,
        enumerable: true,
        set: function (val) {
            if (typeof val === "number") {
                val = Math.floor(val);
                let privateThis = _videosWeakMap.get(this);
                if (privateThis) {
                    privateThis._x = val;
                    _rt.callCustomCommand({
                        success: function (res) { },
                        fail: function (res) { }
                    }, "sud-video-posx", this.instanceID, val);
                }
            } else {
                console.warn("set video property with invalid value!");
            }
        },
        get: function () {
            let privateThis = _videosWeakMap.get(this);
            return privateThis ? privateThis._x : 0;
        }
    });

    Object.defineProperty(_rt.Video.prototype, "y", {
        configurable: false,
        enumerable: true,
        set: function (val) {
            if (typeof val === "number") {
                val = Math.floor(val);
                let privateThis = _videosWeakMap.get(this);
                if (privateThis) {
                    privateThis._y = val;
                    _rt.callCustomCommand({
                        success: function (res) { },
                        fail: function (res) { }
                    }, "sud-video-posy", this.instanceID, val);

                }
            } else {
                console.warn("set video property with invalid value!");
            }

        },
        get: function () {
            let privateThis = _videosWeakMap.get(this);
            return privateThis ? privateThis._y : 0;
        }
    });

    Object.defineProperty(_rt.Video.prototype, "width", {
        configurable: false,
        enumerable: true,
        set: function (val) {
            if (typeof val === "number") {
                val = Math.floor(val);
                let privateThis = _videosWeakMap.get(this);
                if (privateThis) {
                    privateThis._width = val;
                    _rt.callCustomCommand({
                        success: function (res) { },
                        fail: function (res) { }
                    }, "sud-video-width", this.instanceID, val);

                }
            } else {
                console.warn("set video property with invalid value!");
            }
        },
        get: function () {
            let privateThis = _videosWeakMap.get(this);
            return privateThis ? privateThis._width : 0;
        }
    });

    Object.defineProperty(_rt.Video.prototype, "height", {
        configurable: false,
        enumerable: true,
        set: function (val) {
            if (typeof val === "number") {
                val = Math.floor(val);
                let privateThis = _videosWeakMap.get(this);
                if (privateThis) {
                    privateThis._height = val;
                    _rt.callCustomCommand({
                        success: function (res) { },
                        fail: function (res) { }
                    }, "sud-video-height", this.instanceID, val);

                }
            } else {
                console.warn("set video property with invalid value!");
            }
        },
        get: function () {
            let privateThis = _videosWeakMap.get(this);
            return privateThis ? privateThis._height : 0;
        }
    });

    Object.defineProperty(_rt.Video.prototype, "underGameView", {
        configurable: false,
        enumerable: true,
        set: function (val) {
            let privateThis = _videosWeakMap.get(this);
            if (privateThis) {
                if (typeof val === "boolean") {
                    privateThis._underGameView = val;
                    _rt.callCustomCommand({
                        success: function (res) { },
                        fail: function (res) { }
                    }, "sud-video-under-game-view", this.instanceID, this.x, this.y, this.width, this.height, val);
                } else if (val == null) {
                    privateThis._underGameView = val;
                    _rt.callCustomCommand({
                        success: function (res) { },
                        fail: function (res) { }
                    }, "sud-video-disable", this.instanceID);
                } else {
                    console.warn("set property underGameView with a invalid value!");
                    return null;
                }

            }
        },
        get: function () {
            let privateThis = _videosWeakMap.get(this);
            return privateThis ? privateThis._underGameView : false;
        }
    });

    Object.defineProperty(_rt.Video.prototype, "backgroundColor", {
        configurable: false,
        enumerable: true,
        set: function (val) {
            let privateThis = _videosWeakMap.get(this);
            if (privateThis) {
                if (typeof val === "string" && val.length == 7) {
                    privateThis._backgroundColor = val;
                    _rt.callCustomCommand({
                        success: function (res) { },
                        fail: function (res) { }
                    }, "sud-video-background-color", this.instanceID, val);
                } else {
                    console.warn("set property backgroundColor with a invalid value!");
                    return null;
                }
            }
        },
        get: function () {
            let privateThis = _videosWeakMap.get(this);
            return privateThis ? privateThis._backgroundColor : false;
        }
    });

    Object.defineProperty(_rt.Video.prototype, "objectFit", {
        configurable: false,
        enumerable: true,
        set: function (val) {
            let privateThis = _videosWeakMap.get(this);
            if (privateThis) {
                switch (val) {
                    case "fill":
                    case "contain":
                    case "cover":
                        break;
                    default:
                        console.warn("set property objectFit with a invalid value!");
                        return;
                }
                privateThis._objectFit = val;
                _rt.callCustomCommand({
                    success: function (res) { },
                    fail: function (res) { }
                }, "sud-video-objectfit", this.instanceID, this.videoWidth, this.videoHeight, privateThis._objectFit, this.width, this.height);

            }
        },
        get: function () {
            let privateThis = _videosWeakMap.get(this);
            return privateThis ? privateThis._objectFit : "contain";
        }
    });

    // Video instance registry for Java-to-JS control via runScript
    var __sudControlVideo = function (instanceID, action, args) {
        var video = _videoInstanceRegistry[instanceID];
        if (!video) {
            console.warn("video instance not found: " + instanceID);
            return;
        }
        switch (action) {
            case 'pause':
                if (typeof video.pause === 'function') video.pause();
                break;
            case 'play':
                if (typeof video.play === 'function') video.play();
                break;
            case 'stop':
                if (typeof video.stop === 'function') video.stop();
                break;
            case 'seek':
                if (typeof video.seek === 'function') video.seek(args);
                break;
            case 'destroy':
                if (typeof video.destroy === 'function') video.destroy();
                delete _videoInstanceRegistry[instanceID];
                break;
            default:
                console.warn("unknown video action: " + action);
        }
    };
} else {
    console.error("Video or createVideo is undefined");
}