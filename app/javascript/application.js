// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require rails-ujs
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import { Application } from "@hotwired/stimulus"
window.Stimulus = Application.start()
