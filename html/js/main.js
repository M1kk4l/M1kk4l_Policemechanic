$(function () {
    $(".container").css("display", "none !important")
    $(".container").hide()
    $(".column").hide()

    window.addEventListener("message", function (event) {
        item = event.data;
        if (item.type === "container") {
            if (item.status) {
                $(".container").css("display", "flex !important")
                $(".container").show()
            } else {
                $(".container").css("display", "none !important")
                $(".container").hide()
            }
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $(".container").css("display", "none !important")
            $(".container").hide()
            $(".column").hide()
            $.post(`http://${item.resource}/close`, JSON.stringify({}));
        }
    };

    $('body').on('click','#closeContainer',function() {
        $(".container").css("display", "none !important")
        $(".container").hide()
        $(".column").hide()
        $.post(`http://${item.resource}/close`, JSON.stringify({}));
    });

    $('body').on('click','#closeColumn',function() {
        $(".container").css("display", "none !important")
        $(".container").hide()
        $(".column").hide()
        $.post(`http://${item.resource}/close`, JSON.stringify({}));
    });

    new Vue({
        el: '#app',
        vuetify: new Vuetify(),
        methods: {
            Repair() {
                setTimeout(() => { 
                    $.post(`http://${item.resource}/Repair`, JSON.stringify({}));
                }, 200);
            },
            Wash() {
                setTimeout(() => { 
                    $.post(`http://${item.resource}/Wash`, JSON.stringify({}));
                }, 200);
            },
            changecolor() {
                setTimeout(() => { 
                    $(".container").css("display", "none !important")
                    $(".container").hide()
                    $(".column").show()
                    startup()
                }, 200);
            },
            SubmitColor() {
                setTimeout(() => { 
                    $.post(`http://${item.resource}/close`, JSON.stringify({}));
                    $(".column").hide()
                }, 200);
            }
        }
    })

    var primary;
    var defaultColor = "#0000ff";

    function startup() {
        primary = document.querySelector("#primary");
        primary.value = defaultColor;
        primary.addEventListener("input", updatePrimary, false);
        primary.select();
    
    
        secondary = document.querySelector("#secondary");
        secondary.value = defaultColor;
        secondary.addEventListener("input", updateSecondary, false);
        secondary.select();
    }
  
    function updatePrimary(event) {
        color = event.target.value
        color = hexToRGB(color)
    
        rgb = color.split(",")
        $.post(`http://${item.resource}/primaryColor`, JSON.stringify({rgb}));
    }
  
    function updateSecondary(event) {
        color = event.target.value
        color = hexToRGB(color)
    
        rgb = color.split(",")
        $.post(`http://${item.resource}/SecondaryColor`, JSON.stringify({rgb}));
    }
  
  
    function hexToRGB(h) {
        let r = 0, g = 0, b = 0;
    
        // 3 digits
        if (h.length == 4) {
        r = "0x" + h[1] + h[1];
        g = "0x" + h[2] + h[2];
        b = "0x" + h[3] + h[3];
    
        // 6 digits
        } else if (h.length == 7) {
        r = "0x" + h[1] + h[2];
        g = "0x" + h[3] + h[4];
        b = "0x" + h[5] + h[6];
        }
    
        return ""+ +r + "," + +g + "," + +b + "";
    }
})

