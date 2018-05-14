define({ "api": [
  {
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "optional": false,
            "field": "varname1",
            "description": "<p>No type.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "varname2",
            "description": "<p>With type.</p>"
          }
        ]
      }
    },
    "type": "",
    "url": "",
    "version": "0.0.0",
    "filename": "/home/majun/git/openresty/file_server/doc/main.js",
    "group": "_home_majun_git_openresty_file_server_doc_main_js",
    "groupTitle": "_home_majun_git_openresty_file_server_doc_main_js",
    "name": ""
  },
  {
    "type": "get",
    "url": "/api/download",
    "title": "下载文件, 返回文件数据流",
    "name": "download",
    "group": "api",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "string",
            "optional": false,
            "field": "fid",
            "description": "<p>文件fid.</p>"
          }
        ]
      }
    },
    "version": "0.0.0",
    "filename": "/home/majun/git/openresty/file_server/download.lua",
    "groupTitle": "api"
  },
  {
    "type": "post",
    "url": "/api/upload",
    "title": "文件上传",
    "name": "upload",
    "group": "api",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "string",
            "optional": false,
            "field": "file",
            "description": "<p>本地文件路径</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "json",
            "optional": false,
            "field": "file_info",
            "description": "<p>返回上传文件信息.</p>"
          },
          {
            "group": "Success 200",
            "type": "string",
            "optional": false,
            "field": "file_info.filename",
            "description": "<p>文件名.</p>"
          },
          {
            "group": "Success 200",
            "type": "string",
            "optional": false,
            "field": "file_info.fid",
            "description": "<p>文件id.</p>"
          },
          {
            "group": "Success 200",
            "type": "string",
            "optional": false,
            "field": "file_info.status",
            "description": "<p>文件上传状态.</p>"
          },
          {
            "group": "Success 200",
            "type": "string",
            "optional": false,
            "field": "file_info.time",
            "description": "<p>文件上传时间.</p>"
          }
        ]
      }
    },
    "version": "0.0.0",
    "filename": "/home/majun/git/openresty/file_server/upload.lua",
    "groupTitle": "api"
  }
] });
