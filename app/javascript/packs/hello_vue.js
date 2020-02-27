
import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
import VueResource from 'vue-resource'
import Event from './event.vue'
import App from '../app.vue'

 
Vue.use(VueResource)
Vue.use(TurbolinksAdapter)
 
document.addEventListener('turbolinks:load', () => {
  Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
 
  // var a = document.getElementById("el_app")

  // if (a != null)
  // {
   //   const app = new Vue({
  //     el: '#el_app',      
  //     render: h => h(App)
  //   }).$mount();

  // };
  
  //console.log(app)
  var htmlcalendar = document.getElementById("calendar");
  if (htmlcalendar != null) {
    //var user = JSON.parse(element.dataset.user)
 
    const event = new Vue({
      el: '#calendar',
      render: h => h(Event)
    }).$mount();    

  }
  
    console.log(event)
});

