/*
 * FileChooser.qml
 * Copyright (C) Damien Caliste 2013-2014 <dcaliste@free.fr>
 *
 * FileChooser.qml is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License
 * as published by the Free Software Foundation; version 2.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import Qt.labs.folderlistmodel 1.0

Item {
    id: chooser_item
    function getEntry() {
    }

    Column {
        id: chooser_header
        width: parent.width
        Label {
            width: parent.width
            text: "Picture Chooser"
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            horizontalAlignment: Text.AlignHCenter
        }
        Row {
            id: chooser_head
            width: parent.width
            IconButton {
                id: chooser_back
                icon.source: "image://theme/icon-header-back"
                onClicked: { folderModel.navigateUp() }
            }
            Label {
                width: parent.width - chooser_back.width
                text: folderModel.folder
            }
        }
    }
    FolderListModel {
	    id: folderModel
        folder: Qt.resolvedUrl('~')
        showDirsFirst: true
        rootFolder: Qt.resolvedUrl('/')
        function navigateUp(){
	        if (folderModel.folder == "file:///") {
                return
            } else {    
                folderModel.folder = folderModel.parentFolder
            }
        }
        function fileSelected(fileName,filePath){
            py.call("main.helloMyWorld",[filePath],function(ret){
                pageStack.push(Qt.resolvedUrl("ImageView.qml"))
            })
        }
    }
    SilicaListView {
        id: chooser_list
        anchors.top: chooser_header.bottom
        width: parent.width
        anchors.bottom: parent.bottom
        model: folderModel
	    Formatter {
            id: formatter
        }
        delegate: ListItem {
            id: listItems
            Label { 
                anchors.fill: parent
                anchors.topMargin: Theme.paddingSmall
                color: fileIsDir ? Theme.primaryColor : Theme.secondaryColor
                text: fileName 
            }
            Label {
                font.pixelSize: Theme.fontSizeExtraSmall
                text: formatter.formatDate(fileModified, Formatter.Timepoint) + " - " + formatter.formatFileSize(fileSize)
                color: Theme.secondaryColor
                anchors.rightMargin: Theme.paddingSmall
                anchors.bottom: parent.bottom
            }
            onClicked: { fileIsDir ? folderModel.folder = filePath : folderModel.fileSelected(fileName,filePath)}
        }
	}
}
