<template>
<div>
  <h1>{{dateRange}}</h1>
  <div>
    <select v-model="selectedView">
      <option v-for="(options, index) in viewModeOptions" :value="options.value" :key="index">
        {{options.title}}
      </option>
    </select>
    <span @click="onClickNavi($event)">
      <button type="button" class="btn btn-default btn-sm move-today" data-action="move-today">Hoje</button>
      <button type="button" class="btn btn-default btn-sm move-day" data-action="move-prev">Anterior</button>
      <button type="button" class="btn btn-default btn-sm move-day" data-action="move-next">Próximo</button>
    </span>
    <span class="render-range">{{dateRange}}</span>
  </div>
  <calendar style="height: 800px"
            ref="tuiCal"
            :useDetailPopup="useDetailPopup"
            :view="selectedView"
            :calendars="calendarList"
            :schedules="scheduleList"
            :theme="theme"
            :template="template"
            :taskView="true"
            :scheduleView="true"
            :month="month"
            :week="week"
            :timezones="timezones"
            :disableDblClick="disableDblClick"
            :isReadOnly="isReadOnly"
            @clickSchedule="onClickSchedule"
            @clickDayname="onClickDayname"
            @beforeDeleteSchedule="onBeforeDeleteSchedule"
            @afterRenderSchedule="onAfterRenderSchedule"
            @clickTimezonesCollapseBtn="onClickTimezonesCollapseBtn"
            @beforeCreateSchedule="onBeforeCreateSchedule"
            @beforeUpdateSchedule="onBeforeUpdateSchedule"
  />
</div>
</template>
<script>
import Rails from "@rails/ujs"
import 'tui-time-picker/dist/tui-time-picker.css';
import 'tui-date-picker/dist/tui-date-picker.css';
import 'tui-calendar/dist/tui-calendar.css';
import * as moment from 'moment';

//import './app.css';

import {Calendar} from '@toast-ui/vue-calendar';

const today = new Date();

const getDate = (type, start, value, operator) => {
  start = new Date(start);
  type = type.charAt(0).toUpperCase() + type.slice(1);

  if (operator === '+') {
    start[`set${type}`](start[`get${type}`]() + value);
  } else {
    start[`set${type}`](start[`get${type}`]() - value);
  }

  return start;
};

export default {
  name: 'Event',
  components: {
    'calendar': Calendar,    
  },
  data() {
    return {
      viewModeOptions: [
        {
          title: 'Mensal',
          value: 'month'
        },
        {
          title: 'Semanal',
          value: 'week'
        },
        {
          title: 'Diário',
          value: 'day'
        }
      ],      
      dateRange: '',
      selectedView: 'week',
      calendarList: [
        {
          id: '0',
          name: 'Private',
          bgColor: '#9e5fff',
          borderColor: '#9e5fff'
        },
        {
          id: '1',
          name: 'Company',
          bgColor: '#00a9ff',
          borderColor: '#00a9ff'
        }
      ],
      scheduleList: [],
      // scheduleList: [
      //   {
      //     id: '1',
      //     calendarId: '0',
      //     title: 'TOAST UI Calendar Study',
      //     category: 'time',
      //     dueDateClass: '',
      //     start: today.toISOString(),
      //     end: getDate('hours', today, 3, '+').toISOString(),
      //     location: 'pt-BR'
      //   },
      //   {
      //     id: '2',
      //     calendarId: '1',
      //     title: 'Practice',
      //     category: 'milestone',
      //     dueDateClass: '',
      //     start: getDate('date', today, 1, '+').toISOString(),
      //     end: getDate('date', today, 1, '+').toISOString(),
      //     isReadOnly: true,
      //     location: 'pt-BR'
      //   },
      //   {
      //     id: '3',
      //     calendarId: '1',
      //     title: 'FE Workshop',
      //     category: 'allday',
      //     dueDateClass: '',
      //     start: getDate('date', today, 2, '-').toISOString(),
      //     end: getDate('date', today, 1, '-').toISOString(),
      //     isReadOnly: true,
      //     location: 'pt-BR'
      //   },
      //   {
      //     id: '4',
      //     calendarId: '1',
      //     title: 'Report',
      //     category: 'time',
      //     dueDateClass: '',
      //     start: today.toISOString(),
      //     end: getDate('hours', today, 1, '+').toISOString(),
      //     location: 'pt-BR'
      //   },
      //   {
      //     id: '5',
      //     calendarId: '1',
      //     title: 'Teste',
      //     category: 'time',
      //     dueDateClass: '',
      //     start: moment().toISOString(),
      //     end: moment().add('hours', 2).toISOString(),
      //     location: 'pt-BR'
      //   }
      // ],
      timezones: [{
        timezoneOffset: -180,
        displayLabel: 'GMT-03:00',
        tooltip: 'São Paulo'
      }],
      theme: themeConfig,
      template: {
        milestone(schedule) {
          return `<span style="color:#fff;background-color: ${schedule.bgColor};">${schedule.title}</span>`;
        },
        milestoneTitle() {
          return 'Milestone';
        },
        allday(schedule) {
          return `${schedule.title}<i class="fa fa-refresh"></i>`;
        },
        alldayTitle() {
          return 'Dia todo';
        },
         popupIsAllDay: function() {
            return 'Dia todo';
        },
        popupStateFree: function() {
            return 'Livre';
        },
        popupStateBusy: function() {
            return 'Ocupado';
        },
        titlePlaceholder: function() {
            return 'Título';
        },
        locationPlaceholder: function() {
            return 'Descrição';
        },
        startDatePlaceholder: function() {
            return 'Data Inicial';
        },
        endDatePlaceholder: function() {
            return 'Data Final';
        },
        popupSave: function() {
            return 'Gravar';
        },
        popupUpdate: function() {
            return 'Gravar';
        },
        popupDetailDate: function(isAllDay, start, end) {
            var isSameDate = moment(start).isSame(end);
            var endFormat = (isSameDate ? '' : 'DD/MM/YYYY ') + 'HH:mm';

            if (isAllDay) {
                return moment(start.toDate()).format('DD/MM/YYYY') + (isSameDate ? '' : ' - ' + moment(end).toDate().format('DD/MM/YYYY'));
            }

            return (moment(start.toDate()).format('DD/MM/YYYY HH:mm') + ' - ' + moment(end.toDate()).format(endFormat));
        },
        popupDetailLocation: function(schedule) {
            return 'Descrição : ' + schedule.location;
        },
        popupDetailUser: function(schedule) {
            return 'Usuário : ' + (schedule.attendees || []).join(', ');
        },
        popupDetailState: function(schedule) {
            return 'Estado : ' + schedule.state || 'Busy';
        },
        popupDetailRepeat: function(schedule) {
            return 'Repetir : ' + schedule.recurrenceRule;
        },
        popupDetailBody: function(schedule) {
            return 'Corpo : ' + schedule.body;
        },
        popupEdit: function() {
            return 'Alterar';
        },
        popupDelete: function() {
            return 'Excluir';
        }

      },
      month: {
        startDayOfWeek: 0
      },
      week: {
        showTimezoneCollapseButton: true,
        timezonesCollapsed: true
      },
      taskView: true,
      scheduleView: true,
      useDetailPopup: true,
      disableDblClick: true,
      isReadOnly: false,
      moment: moment
    };
  },
  watch: {
    selectedView(newValue) {
      this.$refs.tuiCal.invoke('changeView', newValue, true);
      this.setRenderRangeText();
    }
  },
  methods: {
    init() {
      this.setRenderRangeText();
    },
    onBeforeCreateSchedule(e){
      console.log(moment());
      console.log(e.start.toDate())  ;
      console.log(e)  ;
      let self = this;
      $.ajax({
        url: "/events.json",
        type: "POST",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        cache: false,
        processData: false,
        data: JSON.stringify({event:
          {
                title: e.title,
                description: e.location,
                start: moment(e.start.toDate()).format('YYYY-MM-DDTHH:mm:ss'), 
                end: moment(e.end.toDate()).format('YYYY-MM-DDTHH:mm:ss'),
                state: e.state, 
                isAllDay: e.isAllDay
          }
        }),
        success: function(data) {
          console.log(data)  ;
          self.getScheduleList();

        },
        error: function(data) {
          console.log('error')  ;
        }
      })
    },
    onBeforeUpdateSchedule(e){
      console.log(moment());
      console.log(e.start.toDate())  ;
      console.log(e)  ;
      let self = this;
      $.ajax({
        url: "/events/"+ e.schedule.id +".json",
        type: "PUT",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        cache: false,
        processData: false,
        data: JSON.stringify({event:
          {
                id: e.schedule.id,
                title: e.changes.title != null ? e.changes.title : e.schedule.title,
                description: e.changes.location != null ? e.changes.location : e.schedule.location,
                start: e.changes.start != null ? moment(e.changes.start.toDate()).format('YYYY-MM-DDTHH:mm:ss'): moment(e.schedule.start.toDate()).format('YYYY-MM-DDTHH:mm:ss'), 
                end: e.changes.end != null ? moment(e.changes.end.toDate()).format('YYYY-MM-DDTHH:mm:ss'): moment(e.schedule.end.toDate()).format('YYYY-MM-DDTHH:mm:ss'),
                state: e.changes.state != null ? e.changes.state : e.schedule.state, 
                isAllDay: e.changes.isAllDay != null ? e.changes.isAllDay : e.schedule.isAllDay
          }
        }),
        success: function(data) {
          console.log(data)  ;
          self.getScheduleList();

        },
        error: function(data) {
          console.log('error')  ;          
          self.getScheduleList();
        }
      })
    },
    setRenderRangeText() {
      const {invoke} = this.$refs.tuiCal;
      const view = invoke('getViewName');
      const calDate = invoke('getDate');
      const rangeStart = invoke('getDateRangeStart');
      const rangeEnd = invoke('getDateRangeEnd');
      let year = calDate.getFullYear();
      let month = calDate.getMonth() + 1;
      let date = calDate.getDate();
      let dateRangeText = '';
      let endMonth, endDate, start, end;

      switch (view) {
        case 'month':
          dateRangeText = moment(rangeStart.toDate()).add('month', 1).format('MM') + '/' +moment(rangeStart.toDate()).format('YYYY');
          break;
        case 'week':
          year = moment(rangeStart.toDate()).format('YYYY');
          month = moment(rangeStart.toDate()).add('month', 1).format('MM');
          date = moment(rangeStart.toDate()).format('DD');
          endMonth = moment(rangeEnd.toDate()).add('month', 1).format('MM');
          endDate = moment(rangeEnd.toDate()).format('DD');

          start = `${date}/${month}/${year}`;
          end = `${endDate}/${endMonth}`;
          dateRangeText = `${start} ~ ${end}`;
          break;
        default:
          dateRangeText = moment(rangeStart.toDate()).format('DD') + '/'+ moment(rangeStart.toDate()).add('month', 1).format('MM') + '/' +moment(rangeStart.toDate()).format('YYYY');
      }
      this.dateRange = dateRangeText;
      this.getScheduleList();
    },
    async getScheduleList(){
      const {invoke} = this.$refs.tuiCal;
      const start = invoke('getDateRangeStart');
      const end = invoke('getDateRangeEnd');

      let self = this;
      var q = 'start=' + moment(start.toDate()).format('YYYY-MM-DDTHH:mm:ss') + '&end=' + moment(end.toDate()).add('days', 1).format('YYYY-MM-DDTHH:mm:ss');

      $.ajax({
        url: "/events.json?"+ q,
        type: "GET",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        cache: false,
        processData: false,
        
        success: function(data) {
          self.scheduleList = [];
          for (var i = 0; i < data.length; i++){
            
            self.scheduleList.push({
              id: data[i].id,
              calendarId: '0',
              title: data[i].title,
              category: data[i].isAllDay == 1 ? 'allday' : 'time',
              state: data[i].state,
              dueDateClass: '',
              start: self.moment(data[i].start).format('YYYY-MM-DDTHH:mm:ss'),
              end: self.moment(data[i].end).format('YYYY-MM-DDTHH:mm:ss'),
              location: data[i].description,
              //isReadOnly: false// aqui
              isReadOnly: data[i].user_id != self.getUserId()
              
            });
          }          
        },
        error: function(data) {
          console.log('error')  ;
        }
      })
    },
    getUserId(){
      return document.cookie.match('(^|;) ?' + 'id' + '=([^;]*)(;|$)')[2]
    },
    onClickNavi(event) {
      if (event.target.tagName === 'BUTTON') {
        const {target} = event;
        let action = target.dataset ? target.dataset.action : target.getAttribute('data-action');
        action = action.replace('move-', '');

        this.$refs.tuiCal.invoke(action);
        this.setRenderRangeText();
      }
    },
    onClickSchedule(res) {
      console.group('onClickSchedule');
      console.log('MouseEvent : ', res.event);
      console.log('Calendar Info : ', res.calendar);
      console.log('Schedule Info : ', res.schedule);
      console.groupEnd();
    },
    onClickDayname(res) {
      // view : week, day
      console.group('onClickDayname');
      console.log(res.date);
      console.groupEnd();
    },
    onBeforeDeleteSchedule(res) {
      console.group('onBeforeDeleteSchedule');
      console.log('Schedule Info : ', res.schedule);
      console.groupEnd();      
      let self = this;
      $.ajax({
        url: "/events/"+ res.schedule.id + ".json",
        type: "DELETE",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        cache: false,
        processData: false,     
        success: function(data) {
          console.log(data) ;          
          const idx = self.scheduleList.findIndex(item => item.id === res.schedule.id);
          self.scheduleList.splice(idx, 1);
          self.success('Evento excluído com sucesso');
        },
        error: function(data) {
          console.log('error') ;
          self.error('Não foi possível excluir o evento');
        }
      })

      
    },
    onAfterRenderSchedule(res) {
      console.group('onAfterRenderSchedule');
      console.log('Schedule Info : ', res.schedule);
      console.groupEnd();
    },
    onClickTimezonesCollapseBtn(timezonesCollapsed) {
      // view : week, day
      console.group('onClickTimezonesCollapseBtn');
      console.log('Is Collapsed Timezone? ', timezonesCollapsed);
      console.groupEnd();

      if (timezonesCollapsed) {
        this.theme['week.timegridLeft.width'] = '100px';
        this.theme['week.daygridLeft.width'] = '100px';
      } else {
        this.theme['week.timegridLeft.width'] = '50px';
        this.theme['week.daygridLeft.width'] = '50px';
      }
    },
    error(msg){
      $("#error").html(msg).show();
      setTimeout( function(){$('#error').hide();} , 3000);
    },
    success(title, msg){
      $("#success").html(mdg).show();
      setTimeout( function(){$('#success').hide();} , 3000);
    }
  },
  mounted() {
    this.init();
    console.log('teste');
  }
};


//Thema

 // default keys and styles
var themeConfig = {
    'common.border': '1px solid #e5e5e5',
    'common.backgroundColor': 'white',
    'common.holiday.color': '#ff4040',
    'common.saturday.color': '#333',
    'common.dayname.color': '#333',
    'common.today.color': '#333',
    
    // creation guide style
    'common.creationGuide.backgroundColor': 'rgba(81, 92, 230, 0.05)',
    'common.creationGuide.border': '1px solid #515ce6',
    
    // month header 'dayname'
    'month.dayname.height': '31px',
    'month.dayname.borderLeft': '1px solid #e5e5e5',
    'month.dayname.paddingLeft': '10px',
    'month.dayname.paddingRight': '10px',
    'month.dayname.backgroundColor': 'inherit',
    'month.dayname.fontSize': '12px',
    'month.dayname.fontWeight': 'normal',
    'month.dayname.textAlign': 'left',
    
    // month day grid cell 'day'
    'month.holidayExceptThisMonth.color': 'rgba(255, 64, 64, 0.4)',
    'month.dayExceptThisMonth.color': 'rgba(51, 51, 51, 0.4)',
    'month.weekend.backgroundColor': 'inherit',
    'month.day.fontSize': '14px',
    
    // month schedule style
    'month.schedule.borderRadius': '2px',
    'month.schedule.height': '24px',
    'month.schedule.marginTop': '2px',
    'month.schedule.marginLeft': '8px',
    'month.schedule.marginRight': '8px',
    
    // month more view
    'month.moreView.border': '1px solid #d5d5d5',
    'month.moreView.boxShadow': '0 2px 6px 0 rgba(0, 0, 0, 0.1)',
    'month.moreView.backgroundColor': 'white',
    'month.moreView.paddingBottom': '17px',
    'month.moreViewTitle.height': '44px',
    'month.moreViewTitle.marginBottom': '12px',
    'month.moreViewTitle.backgroundColor': 'inherit',
    'month.moreViewTitle.borderBottom': 'none',
    'month.moreViewTitle.padding': '12px 17px 0 17px',
    'month.moreViewList.padding': '0 17px',
    
    // week header 'dayname'
    'week.dayname.height': '42px',
    'week.dayname.borderTop': '1px solid #e5e5e5',
    'week.dayname.borderBottom': '1px solid #e5e5e5',
    'week.dayname.borderLeft': 'inherit',
    'week.dayname.paddingLeft': '0',
    'week.dayname.backgroundColor': 'inherit',
    'week.dayname.textAlign': 'left',
    'week.today.color': '#333',
    'week.pastDay.color': '#bbb',
    
    // week vertical panel 'vpanel'
    'week.vpanelSplitter.border': '1px solid #e5e5e5',
    'week.vpanelSplitter.height': '3px',
    
    // week daygrid 'daygrid'
    'week.daygrid.borderRight': '1px solid #e5e5e5',
    'week.daygrid.backgroundColor': 'inherit',
    
    'week.daygridLeft.width': '72px',
    'week.daygridLeft.backgroundColor': 'inherit',
    'week.daygridLeft.paddingRight': '8px',
    'week.daygridLeft.borderRight': '1px solid #e5e5e5',
    
    'week.today.backgroundColor': 'rgba(81, 92, 230, 0.05)',
    'week.weekend.backgroundColor': 'inherit',
    
    // week timegrid 'timegrid'
    'week.timegridLeft.width': '72px',
    'week.timegridLeft.backgroundColor': 'inherit',
    'week.timegridLeft.borderRight': '1px solid #e5e5e5',
    'week.timegridLeft.fontSize': '11px',
    'week.timegridLeftTimezoneLabel.height': '40px',
    'week.timegridLeftAdditionalTimezone.backgroundColor': 'white',
    
    'week.timegridOneHour.height': '52px',
    'week.timegridHalfHour.height': '26px',
    'week.timegridHalfHour.borderBottom': 'none',
    'week.timegridHorizontalLine.borderBottom': '1px solid #e5e5e5',
    
    'week.timegrid.paddingRight': '8px',
    'week.timegrid.borderRight': '1px solid #e5e5e5',
    'week.timegridSchedule.borderRadius': '2px',
    'week.timegridSchedule.paddingLeft': '2px',
    
    'week.currentTime.color': '#515ce6',
    'week.currentTime.fontSize': '11px',
    'week.currentTime.fontWeight': 'normal',
    
    'week.pastTime.color': '#bbb',
    'week.pastTime.fontWeight': 'normal',
    
    'week.futureTime.color': '#333',
    'week.futureTime.fontWeight': 'normal',
    
    'week.currentTimeLinePast.border': '1px dashed #515ce6',
    'week.currentTimeLineBullet.backgroundColor': '#515ce6',
    'week.currentTimeLineToday.border': '1px solid #515ce6',
    'week.currentTimeLineFuture.border': 'none',
    
    // week creation guide style
    'week.creationGuide.color': '#515ce6',
    'week.creationGuide.fontSize': '11px',
    'week.creationGuide.fontWeight': 'bold',
    
    // week daygrid schedule style
    'week.dayGridSchedule.borderRadius': '2px',
    'week.dayGridSchedule.height': '24px',
    'week.dayGridSchedule.marginTop': '2px',
    'week.dayGridSchedule.marginLeft': '8px',
    'week.dayGridSchedule.marginRight': '8px'
    };

</script>
<style>
body {
    font-family: 'Noto Sans', sans-serif;
    color: '#333';
    font-size: 12px;
}

/**  custom bootstrap - start */
/* .btn {
    border-radius: 25px;
    border-color: #ddd;
}

.btn:hover {
    border: solid 1px #bbb;
    background-color: #fff;
}

.btn:active {
    background-color: #f9f9f9;
    border: solid 1px #bbb;
    outline: none;
}

.btn:disabled {
    background-color: #f9f9f9;
    border: solid 1px #ddd;
    color: #bbb;
}

.btn:focus:active, .btn:focus, .btn:active {
    outline: none;
} */

.open > .dropdown-toggle.btn-default {
    background-color: #fff;
}

.dropdown-menu {
    top: 25px;
    padding: 3px 0;
    border-radius: 2px;
    border: 1px solid #bbb;
}

.dropdown-menu > li > a {
    padding: 9px 12px;
    cursor: pointer;
}

.dropdown-menu > li > a:hover {
    background-color: rgba(81, 92, 230, 0.05);
    color: #333;
}

.bi15 {
    width: 15px;
    height: 15px;
}
/** custom fontawesome - end */

.calendar-icon {
    width: 14px;
    height: 14px;
}

#top {
    height: 49px;
    border-bottom: 1px solid #bbb;
    padding: 16px;
    font-size: 10px;
}

#lnb {
    position: absolute;
    width: 200px;
    top: 49px;
    bottom: 0;
    border-right: 1px solid #d5d5d5;
    padding: 12px 10px;
    background: #fafafa;
}

#right {
    position: absolute;
    left: 200px;
    top: 49px;
    right: 0;
    bottom: 0;
}

#lnb label {
    margin-bottom: 0;
    cursor: pointer;
}

.lnb-new-schedule {
    padding-bottom: 12px;
    border-bottom: 1px solid #e5e5e5;
}

.lnb-new-schedule-btn {
    height: 100%;
    font-size: 14px;
    background-color: #ff6618;
    color: #ffffff;
    border: 0;
    border-radius: 25px;
    padding: 10px 20px;
    font-weight: bold;
}

.lnb-new-schedule-btn:hover {
    height: 100%;
    font-size: 14px;
    background-color: #e55b15;
    color: #ffffff;
    border: 0;
    border-radius: 25px;
    padding: 10px 20px;
    font-weight: bold;
}

.lnb-new-schedule-btn:active {
    height: 100%;
    font-size: 14px;
    background-color: #d95614;
    color: #ffffff;
    border: 0;
    border-radius: 25px;
    padding: 10px 20px;
    font-weight: bold;
}

.lnb-calendars > div {
    padding: 12px 16px;
    border-bottom: 1px solid #e5e5e5;
    font-weight: normal;
}

.lnb-calendars-d1 {
    padding-left: 8px;
}

.lnb-calendars-d1 label {
    font-weight: normal;
}

.lnb-calendars-item {
    min-height: 14px;
    line-height: 14px;
    padding: 8px 0;
}

.lnb-footer {
    color: #999;
    font-size: 11px;
    position: absolute;
    bottom: 12px;
    padding-left: 16px;
}

#menu {
    padding: 16px;
}

#dropdownMenu-calendarType {
    padding: 0 8px 0 11px;
}

#calendarTypeName {
    min-width: 62px;
    display: inline-block;
    text-align: left;
    line-height: 30px;
}

.move-today {
    padding: 0 16px;
    line-height: 30px;
}

.move-day {
    padding: 8px;
}

.render-range {
    padding-left: 12px;
    font-size: 19px;
    vertical-align: middle;
}

.dropdown-menu-title .calendar-icon {
    margin-right: 8px;
}

.calendar-bar {
    width: 16px;
    height: 16px;
    margin-right: 5px;
    display: inline-block;
    border: 1px solid #eee;
    vertical-align: middle;
}

.calendar-name {
    font-size: 14px;
    font-weight: bold;
    vertical-align: middle;
}

.schedule-time {
    color: #005aff;
}

#calendar {
    position: absolute;
    left: 0;
    right: 0;
    bottom: 5px;
    top: 64px;
}

/** custom fontawesome */
.fa {
    width: 12px;
    height: 12px;
    margin-right: 2px;
}

.tui-full-calendar-month-week-item .tui-full-calendar-today .tui-full-calendar-weekday-grid-date-decorator {
    background-color: #009688;
}
</style>

