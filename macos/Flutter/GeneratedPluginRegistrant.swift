//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import audio_session
import flutter_blue_plus_darwin
import flutter_thermal_printer
import just_audio
import media_kit_libs_macos_audio
import network_info_plus
import package_info_plus
import path_provider_foundation
import printing
import screen_retriever_macos
import shared_preferences_foundation
import wakelock_plus
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AudioSessionPlugin.register(with: registry.registrar(forPlugin: "AudioSessionPlugin"))
  FlutterBluePlusPlugin.register(with: registry.registrar(forPlugin: "FlutterBluePlusPlugin"))
  FlutterThermalPrinterPlugin.register(with: registry.registrar(forPlugin: "FlutterThermalPrinterPlugin"))
  JustAudioPlugin.register(with: registry.registrar(forPlugin: "JustAudioPlugin"))
  MediaKitLibsMacosAudioPlugin.register(with: registry.registrar(forPlugin: "MediaKitLibsMacosAudioPlugin"))
  NetworkInfoPlusPlugin.register(with: registry.registrar(forPlugin: "NetworkInfoPlusPlugin"))
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  PrintingPlugin.register(with: registry.registrar(forPlugin: "PrintingPlugin"))
  ScreenRetrieverMacosPlugin.register(with: registry.registrar(forPlugin: "ScreenRetrieverMacosPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  WakelockPlusMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockPlusMacosPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
