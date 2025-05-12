import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

export const permissionMessageMap: Map<Permissions, string> = new Map([
  ['ohos.permission.APPROXIMATELY_LOCATION', '定位'],
  ['ohos.permission.LOCATION', '定位'],
  ['ohos.permission.ACCELEROMETER', '定位'],
  ["ohos.permission.CAMERA", '相机'],
  ["ohos.permission.MICROPHONE", "麦克风"],
  ["ohos.permission.ACCELEROMETER", "传感器"],
  ["ohos.permission.GYROSCOPE", "传感器"]]
)

export interface IRequestModel {
  flag: boolean //true:第一次申请
  permissionList: Array<Permissions> //为申请通过的权限列表
}

class PermissionManager {


  /*
   * @des 校验权限是否已经申请
   * @param permissions 权限
   * @return 权限是否已经申请通过
   * @auth LiHaoJia
   * */
  checkPermission(permissions: Permissions) {
    //访问控制管理：获取访问控制模块对象。
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    //授权状态
    let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;
    // 获取应用程序的accessTokenID,要校验的目标应用的身份标识。通过bundleInfo进行获取
    let tokenId: number = 0;
    try {
      //获取当前的bundleInfo
      let bundleInfo: bundleManager.BundleInfo =
        bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
    }

    // 校验应用是否被授予权限
    try {
      grantStatus = atManager.checkAccessTokenSync(tokenId, permissions);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
    }
    return grantStatus
  }

  /*
   * @des 申请权限
   * @param permissions 权限
   * @auth LiHaoJia
   * @return 返回IRequestModel
    */
  async requestPermission(permissions: Array<Permissions> | Permissions) {

    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let context: Context = getContext() as common.UIAbilityContext;
    let permissionList: Array<Permissions> = new Array<Permissions>();
    let permissionFail: Array<Permissions> = new Array<Permissions>();
    permissions = Array.isArray(permissions) ? permissions : [permissions]
    //筛选未申请通过的权限
    for (let event of permissions) {
      if (this.checkPermission(event) === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        permissionList.push(event)
      }
    }
    let requestRes: IRequestModel = {
      flag: true, //第一次申请权限
      permissionList: permissionList
    }
    if (permissionList.length === 0) {
      return requestRes
    } else {
      try {
        let res = await atManager.requestPermissionsFromUser(context, permissionList)
        let authRes = res.authResults
        let dialogRes = res.dialogShownResults
        authRes.forEach((item, index) => {
          if (item !== 0) {
            permissionFail.push(res.permissions[index] as Permissions)
          }
        })
        requestRes.permissionList = permissionFail
        if (dialogRes && dialogRes.some(item => item === true)) {
          requestRes.flag = true
        } else {
          requestRes.flag = false
        }
      } catch (e) {
        console.log(e, 'requestPermission')
      }
    }
    return requestRes
  }

  /*
   * @des 权限首次申请失败，再次申请。
   * @param 申请权限列表
   * @return 权限申请结果 （-1 未授权， 0已经授权）
   * @auth LiHaoJia
   * */
  async requestAgainPermission(permissions: Array<Permissions>, isGroup: boolean = false) {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let context: Context = getContext() as common.UIAbilityContext;
    let result: abilityAccessCtrl.GrantStatus[] = []
    try {
      if (isGroup) {
        result = await atManager.requestPermissionOnSetting(context, permissions)
      } else {
        for (let event of permissions) {
          let res = await atManager.requestPermissionOnSetting(context, [event])
          result.push(...res)
        }
      }
    } catch (err) {
      console.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
    }
    return result
  }

}

export const permissionManager = new PermissionManager()