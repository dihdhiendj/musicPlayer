import QtQuick

TikoButton {
    id: tikoComboxButton
    onClicked: tikoPopup.open()
    property var data: []
    property int show: 0

    TikoPopup{
        id: tikoPopup
        x: 0
        y: tikoComboxButton.y + tikoComboxButton.height
        width: tikoComboxButton.width
        height: column.height
        padding: 0

        Column{
            id: column
            spacing: 0

            Repeater{
                model: ListModel{
                    id: listModel
                }

                delegate: TikoButton{
                    radius: 0
                    text: tikoComboxButton.data[index]
                    width: tikoComboxButton.width
                    onClicked: {
                        tikoComboxButton.text = this.text
                        tikoPopup.close()
                    }
                }
            }
        }

        Component.onCompleted: {
            tikoComboxButton.text = tikoComboxButton.data[show]
            for(let i=0; i<tikoComboxButton.data.length; i++){
                listModel.append({index:i})
            }
        }
    }
}
