# Camera Widget for HADashboard

![alt tag](https://cloud.githubusercontent.com/assets/21313598/19617980/ab10dc16-988a-11e6-9117-28e03fe26e9c.jpg)

HADashboard is a dashboard for Home Assistant that is intended to be wall mounted, and is optimized for distance viewing.
https://github.com/home-assistant/hadashboard

This Camera Widget is based on the camera widget for dashing
https://github.com/grubernaut/camera-widget

Camera Widget use the Home Assistant camera api to retrieve camera images for every N seconds. So if your camera is already working on home assistant, then you can use this camera widget in HaDashboard.

## Getting Started

Copy the contents of the assets, jobs, and widgets directories to your dashing installation.

Edit the jobs/cameras.rb file.

Edit your HADashboard to include the views for each camera widget that you would like to display. Inside the cameras controller there are names for each camera, ie: camera1, camera2, camera3 and so on. You can use the included dashboard configuration as a guide for setting up the camera widgets view.