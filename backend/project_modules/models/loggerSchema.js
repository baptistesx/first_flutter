var log4js = require("log4js")

log4js.configure({
  appenders: {
    global: {
      type: "file",
      filename: "logs/global.log",
      layout: {
        type: "pattern",
        pattern: "%x{getDate} [%p] %m", //x:date, p:lvl, m:msg
        tokens: {
          getDate: function (data) {
            const date = new Date();
            var day = date.getDate();
            var monthIndex = date.getMonth();
            if (monthIndex < 10) {
              monthIndex = "0"+monthIndex
            }
            var year = date.getFullYear();
            var hours = date.getHours();
            var minutes = date.getMinutes();
            var seconds = date.getSeconds();
            return '['+day + '/' + monthIndex + '/' + year + ' ' + hours + ':' + minutes + ':'+ seconds+']';
          }
        }
      }
    },
    console: {
      type: 'stdout'
    }
  },
  categories: {
    default: {
      appenders: ["global", "console"],
      level: "all"
    }
  }
})
module.exports.logger = log4js.getLogger("global")