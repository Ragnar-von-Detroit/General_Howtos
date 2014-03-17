# Get Day, Month and Year

    var today = new Date();
    var year = today.getFullYear();
    var month = today.getMonth() + 1; //getMonth starts with 0
    var day = today.getDate(); //getDay returns current weekday [0-6]

    alert('date:: ' + year + '-' + month + '-' + day);

    if (month < 10) {
        month = '0' + month;
    }
    if (day < 10) {
        day = '0' + day;
    }

    alert('date:: ' + year + '-' + month + '-' + day);