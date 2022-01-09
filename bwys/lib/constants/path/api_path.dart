/// class for having API Endpoints used in the application
abstract class AppRestEndPoints {
  /// API end points for the video service
  static const String videoList = '/videoList';

  /// API end points for the user service
  static const String usersList = '/users';
  static const String userDetail = '/users/:id';
  static const String login = '/users/login';
  static const String logout = '/users/:id/logout';
  static const String forgotPassword = '/users/forgotPassword';
  static const String changePassword = '/users/changePassword';
  static const String acceptLicense = '/users/acceptLicense';
  static const String locationPreference = '/users/settings/locations';
  static const String userSettings = '/users/settings';
  static const String userProfileImage = '/users/profile/image';
  static const String userUpstreamColumnSettings = '/users/settings/dataTab';
  static const String notificationsList = '/users/notifications/list';
  static const String markNotificationsAsRead = '/users/notifications';
  static const String updateUserDeviceToken = '/users/deviceTokens';
  static const String userWidgetSettings = '/users/settings/widget';
  static const String topTechniciansList = '/users/top/technicians';
  static const String userColorSettings = '/users/settings/colors';
  static const String getpolygon = '/users/polygons/list';
  static const String deletePolygon = '/users/polygons/delete';
  static const String savePolygon = '/users/polygon';

  /// API end points for the PNM service
  static const String modules = '/pnm/modules';
  static const String ldapStatus = '/pnm/ldapStatus';
  static const String timezones = '/pnm/timezones';
  static const String rescanJobStatus = '/pnm/rescanJobStatus/:job_id';
  static const String appConstants = '/pnm/constants';
  static const String appConfigs = '/pnm/config';
  static const String broadcasts = '/pnm/broadcast';
  static const String createUnsubmittedCorrelation =
      '/pnm/fixedImpairments/unSubmittedCorrelation';
  static const String checkForIFixedIt =
      '/pnm/fixedImpairments/impairmentStatus';
  static const String unsubmittedFixedImpairments =
      '/pnm/fixedImpairments/unSubmitted';
  static const String submittedFixedImpairments =
      '/pnm/fixedImpairments/submitted';
  static const String fixImpairmentIssues = '/pnm/workOrders/issueList';
  static const String fixImpairment = '/pnm/fixedImpairments';
  static const String fixImpairmentAttachments =
      '/pnm/fixedImpairments/:id/attachments';
  static const String workOrders = '/pnm/workOrders';
  static const String updateWorkOrder = '/pnm/workOrders/:id';
  static const String workOrderComments = '/pnm/workOrders/:id/comments';
  static const String workOrderAttachments = '/pnm/workOrders/:id/attachments';
  static const String toolTips = '/pnm/tooltips';
  static const String mapPolygonData = '/pnm/polygon';

  /// API end points for the Modem service
  static const String singleModemRescan = '/modems/rescan';
  static const String multipleModemRescan = '/modems/multipleRescan';
  static const String spectraRescan = '/modems/spectraRescan';
  static const String rxmerRescan = '/modems/rxMerRescan';
  static const String searchCMTSForModem = '/modems/:mac_address/cmts';
  static const String installModem = '/modems/:mac_address/install';
  static const String failedModems = '/modems/failed';
  static const String markModemAsComplete = '/modems/:mac_address/complete';
  static const String birthCertificate =
      '/modems/:mac_address/birthCertificates';
  static const String birthCertiifcateUpstreamDownstream =
      '/modems/:mac_address/birthCertificate/upStreamDownStream';
  static const String birthCertificateSpectraData =
      '/modems/:mac_address/birthCertificate/spectra';
  static const String birthCertificateRxMERData =
      '/modems/:mac_address/birthCertificate/rxmer';
  static const String birthCertificateNote =
      '/modems/:mac_address/birthCertificate/note';
  static const String modemSpectraData = '/modems/:mac_address/spectra';
  static const String modemRescanSpectraData =
      '/modems/:mac_address/rescannedSpectra';
  static const String updateSpectraData =
      '/modems/:mac_address/birthCertificate/spectra';
  static const String updateRxMERData =
      '/modems/:mac_address/birthCertificate/rxmer';
  static const String modemData = '/modems';
  static const String modemPrimaryData = '/modems/primaryChannels';
  static const String modemDownstreamData = '/modems/:mac_address/downstream';
  static const String userWatchList = '/modems/userWatchList';
  static const String modemsSearch = '/modems/search';
  static const String corrGroupSearch = '/modems/correlationWidget';
  static const String corrGroupDetails = '/modems/correlation';
  static const String corrGroupRescan = '/modems/correlationRescan';
  static const String corrGroupRescanSummary =
      '/modems/correlationRescanSummary';
  static const String nodeRescanSummary = '/modems/nodeRescanSummary';
  static const String modemPopupInfo = '/modems/infoWindow';
  static const String correlationMapModems = '/modems/correlationMap';
  static const String updateSubscriberInfo = '/modems/subscriberInfo';
  static const String modemsSeverityCount = '/modems/severityCount';
  static const String modemsStatusCount = '/modems/statusCount';
  static const String criticalModems = '/modems/critical';
  static const String spectraImpairedModems = '/modems/spectraWidget';
  static const String rxmerData = '/modems/:mac_address/rxMer';
  static const String modemRescanSummary = '/modems/modemsRescanSummary';
  static const String birthCertificateList = '/modems/birthCertificate';
  static const String fbcClutser = '/modems/fbcClusters';
  static const String rxmerCluster = '/modems/rxmerClusters';
  static const String modemsImpairments = '/modems/impairments/';
  static const String fbcClusterDetails = '/modems/fbcClusterDetails';
  static const String rxmerClusterDetails = '/modems/rxmerClusterDetails';
  static const String fbcCorrelationWidget = '/modems/fbcCorrelationWidget';
  static const String rxMERCorrelationWidget = '/modems/rxmerCorrelationWidget';
  static const String pingModem = '/modems/ping';
  static const String rebootModem = '/modems/reboot';

  /// API end points for the CMTS service
  static const String cmts = '/cmts';
  static const String spectraHistoricalPollTime =
      '/cmts/spectra/historicalPollTimes';
  static const String nodesSearch = '/cmts/nodes/search';
  static const String nodeRescan = '/cmts/node/rescan';
  static const String nodeInfo = '/cmts/nodes/infoWindow';
  static const String cmtsInfoWindow = '/cmts/infoWindow';
  static const String cmtsMaxStoprFrequency = '/cmts/:cmts_id/maxStopFrequency';
  static const String secondaryChannels =
      '/cmts/:cmts_id/interfaces/:interface_id/secondaryChannels';
  static const String cmtsHealth = '/cmts/:cmts_id/nodes/health';
  static const String corrGroupSearchNodename = '/cmts/nodes/correlation';

  /// API end points for analyzer service
  static const String analyzer = '/analyzer';
  static const String usMonitorCMTSSettings =
      '/analyzer/monitor/cmts/:cmts_id/settings';
  static const String monitor = '/analyzer/monitor/';

  /// API end points for GIS API
  static const String modemsWorstSeverity =
      '/gis-api/data/modems/:mac_addresses';
  static const String nodeDensePoint =
      '/gis-api/data/node-dense-point/:cmts_id';
  static const String correlationDensePoint =
      '/gis-api/data/correlation-dense-point/:cmts_id';
  static const String cmtsDensePoint = '/gis-api/data/cmts-location/:cmts_id';
  static const String getSubscriberInfo =
      '/gis-api/data/modems-subscriber-info';
  static const String modemsDensePoint = '/gis-api/data/modems-dense-point';
  static const String cliLeakagePopupInfo = '/gis-api/data/cli_leakage/:id';
}
