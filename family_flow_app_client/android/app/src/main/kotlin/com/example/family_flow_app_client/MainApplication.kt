package com.example.family_flow_app_client

import android.app.Application

import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
  override fun onCreate() {
    super.onCreate()
    MapKitFactory.setApiKey("a6f9dfc0-7ab3-44c1-a592-fc6086fd98cd") // Your generated API key
  }
}