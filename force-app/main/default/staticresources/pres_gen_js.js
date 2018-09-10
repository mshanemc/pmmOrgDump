/* globals gapi,presentationGenerator */
// Client ID and API key from the Developer Console
// var CLIENT_ID = '752625394736-gqspvn5brkkqqt7spgh2n6l6gu5nao6i.apps.googleusercontent.com';




var CLIENT_ID = '750310122731-ob228q5uae3m8vdomcn4763ahogc8t1k.apps.googleusercontent.com';

var API_KEY = 'AIzaSyApiBE8RcWgHhT5I2mspBWGo0x2cd2xi_Q';
var ogSlideId = '1fHxwC_fLIv6HMZfJ13LYzMIZjOYBbZ2PqKy6l8U8Q2s';

// Array of API discovery doc URLs for APIs used by the quickstart
// var DISCOVERY_DOCS = ["https://slides.googleapis.com/$discovery/rest?version=v1", "https://www.googleapis.com/discovery/v1/apis/drive/v3/rest"];

// Authorization scopes required by the API; multiple scopes can be
// included, separated by spaces.
var SCOPES = "https://www.googleapis.com/auth/drive";


/**
 *  On load, called to load the auth2 library and API client library.
 */
function handleClientLoad() {
  gapi.load('client:auth2', initClient);
}

function readyAuth(){
  document.getElementById("creator").style.display = 'block';
  document.getElementById('create-button').onclick = handleCreateClick;
}

function initClient() {
  var GAPI_TOKEN;

  console.log('initing the client');
  presentationGenerator.getAccessToken(function (result, event) {
    GAPI_TOKEN = result;
    console.log(`token is ${GAPI_TOKEN}`);

    gapi.client.setApiKey(API_KEY);
    gapi.client.setToken({ access_token: GAPI_TOKEN });

    gapi.client.load('drive', 'v3', null);
    document.getElementById("creator").style.display = 'block';
    document.getElementById('create-button').onclick = handleCreateClick;

  });
}

function handleCreateClick(event) {
  console.log('create button going');

  newSlide("loading...")

  //get customer name
  var customerName = document.getElementById("customer-name").value;
  //get presenter name and title
  var presenterName = document.getElementById("presenter-name").value;
  var presenterTitle = document.getElementById("presenter-title").value;
  var presenterEmail = document.getElementById("presenter-email").value;


  //get intro message track
  var cat11 = document.getElementById("cat1-1");
  var cat12 = document.getElementById("cat1-2");

  //get about Salesforce
  var cat21 = document.getElementById("cat2-1");
  var cat22 = document.getElementById("cat2-2");

  //get business challenge
  var cat31 = document.getElementById("cat3-1");
  var cat32 = document.getElementById("cat3-2");
  var cat33 = document.getElementById("cat3-3");
  var cat34 = document.getElementById("cat3-4");
  var cat35 = document.getElementById("cat3-5");
  var cat36 = document.getElementById("cat3-6");
  var cat37 = document.getElementById("cat3-7");
  var cat38 = document.getElementById("cat3-8");
  var cat39 = document.getElementById("cat3-9");

  //get differentiators
  var cat41 = document.getElementById("cat4-1");
  var cat42 = document.getElementById("cat4-2");
  var cat43 = document.getElementById("cat4-3");
  var cat44 = document.getElementById("cat4-4");

  //get industry
  var cat51 = document.getElementById("cat5-1");
  var cat52 = document.getElementById("cat5-2");
  var cat53 = document.getElementById("cat5-3");
  var cat54 = document.getElementById("cat5-4");
  var cat55 = document.getElementById("cat5-5");
  var cat56 = document.getElementById("cat5-6");
  var cat57 = document.getElementById("cat5-7");
  var cat58 = document.getElementById("cat5-8");
  var cat59 = document.getElementById("cat5-9");
  var cat510 = document.getElementById("cat5-10");

  //get size of business
  var cat61 = document.getElementById("cat6-1");
  var cat62 = document.getElementById("cat6-2");

  //duplicate presentation
  var request = {
    name: customerName + " Customized Sales Cloud First Call Deck"
  };

  //create object of slide references
  let categories = {
    "sc101": [],
    "ai": [],
    "sources": [],
    "progress": [],
    "customize": [],
    "cpq": [],
    "mobile": [],
    "lightning": [],
    "pardot": [],
    "prm": [],
    "einstein": [],
    "mfg": [],
    "fins": [],
    "tech": [],
    "life": [],
    "media": [],
    "nonprofit": [],
    "proserv": [],
    "real": [],
    "retail": [],
    "travel": [],
    "ebu": [],
    "cbu": [],
    "positioning": [],
    "salesforce": [],
    "industry": [],
    "platform": [],
    "trailhead": [],
    "appexchange": [],
    "progress": []
  }


  // copy original slide deck
  gapi.client.drive.files.copy({
    fileId: ogSlideId,
    resource: request
  }).then((driveResponse) => {
    var presentationCopyId = driveResponse.result.id;
    console.log("presentationCopyId");
    console.log(presentationCopyId);

    newSlide("loading... part 1 of 3 complete")


    gapi.client.slides.presentations.get({
      presentationId: presentationCopyId
    }).then(function (response) {
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      newSlide("loading... part 2 of 3 complete")


      // START UPDATING THE PRESENTATION
      const presentation = response.result;

      let requests = [];

      //iterate through each slide
      presentation.slides.forEach((slide, index) => {
        //console.log(slide);
        //debugger
        //console.log("find presenter name");

        // find presenter name and title object
        slide.pageElements.forEach(pageEl => {

          if (pageEl.shape && pageEl.shape.text) {

            pageEl.shape.text.textElements.forEach(shape => {

              if (shape.textRun) {
                const content = shape.textRun.content;

                if (content === "Presenter Name, Title of Presenter") {

                  requests.push(...createRequest(pageEl.objectId, "update", presenterName + ", " + presenterTitle))

                }

                if (content === "email@salesforce.com, @twitterhandle") {
                  requests.push(...createRequest(pageEl.objectId, "update", presenterEmail))

                }


              }

            });

          }

        });

        slide.slideProperties.notesPage.pageElements.forEach(element => {
          const shape = element.shape;

          if (shape.text) {
            shape.text.textElements.forEach(textEl => {
              if (textEl.textRun) {
                const noteContent = textEl.textRun.content;

                if (noteContent.indexOf('{') == 0 && noteContent.lastIndexOf('}' == 0)) {
                  console.log("noteContent --> " + index);
                  console.log(noteContent);

                  //convert to JSON
                  const noteJSON = JSON.parse(noteContent);

                  const tags = noteJSON.tags;

                  tags.forEach(tag => {
                    //find category, add slide obj ID

                    addUnique(categories[tag], slide.objectId)

                  });
                }
              }
            });
          }


        });
        // categorize slides



      });

      let slidesToDelete = [];
      let slidesToKeep = [];

      //get intro message track
      if (!cat11.checked) {
        //get category
        slidesToDelete.push(...categories.sc101)
      } else {
        slidesToKeep.push(...categories.sc101)
      }
      if (!cat12.checked) {
        //get category
        slidesToDelete.push(...categories.ai)
      } else {
        slidesToKeep.push(...categories.ai)
      }

      //get about Salesforce
      if (!cat21.checked) {
        //get category
        slidesToDelete.push(...categories.salesforce)
      } else {
        slidesToKeep.push(...categories.salesforce)
      }
      if (!cat22.checked) {
        //get category
        slidesToDelete.push(...categories.positioning)
      } else {
        slidesToKeep.push(...categories.positioning)
      }

      //get business challenge
      if (!cat31.checked) {
        //get category
        slidesToDelete.push(...categories.sources)
      } else {
        slidesToKeep.push(...categories.sources)
      }
      if (!cat32.checked) {
        //get category
        slidesToDelete.push(...categories.progress)
      } else {
        slidesToKeep.push(...categories.progress)
      }
      if (!cat33.checked) {
        //get category
        slidesToDelete.push(...categories.customize)
      } else {
        slidesToKeep.push(...categories.customize)
      }
      if (!cat34.checked) {
        //get category
        slidesToDelete.push(...categories.cpq)
      } else {
        slidesToKeep.push(...categories.cpq)
      }
      if (!cat35.checked) {
        //get category
        slidesToDelete.push(...categories.mobile)
      } else {
        slidesToKeep.push(...categories.mobile)
      }
      if (!cat36.checked) {
        //get category
        slidesToDelete.push(...categories.lightning)
      } else {
        slidesToKeep.push(...categories.lightning)
      }
      if (!cat37.checked) {
        //get category
        slidesToDelete.push(...categories.pardot)
      } else {
        slidesToKeep.push(...categories.pardot)
      }
      if (!cat38.checked) {
        //get category
        slidesToDelete.push(...categories.prm)
      } else {
        slidesToKeep.push(...categories.prm)
      }
      if (!cat39.checked) {
        //get category
        slidesToDelete.push(...categories.einstein)
      } else {
        slidesToKeep.push(...categories.einstein)
      }

      //get differentiators
      if (!cat41.checked) {
        //get category
        slidesToDelete.push(...categories.industry)
      } else {
        slidesToKeep.push(...categories.industry)
      }
      if (!cat42.checked) {
        //get category
        slidesToDelete.push(...categories.platform)
      } else {
        slidesToKeep.push(...categories.platform)
      }
      if (!cat43.checked) {
        //get category
        slidesToDelete.push(...categories.trailhead)
      } else {
        slidesToKeep.push(...categories.trailhead)
      }
      if (!cat44.checked) {
        //get category
        slidesToDelete.push(...categories.appexchange)
      } else {
        slidesToKeep.push(...categories.appexchange)
      }

      //get industry
      if (!cat51.checked) {
        //get category
        slidesToDelete.push(...categories.mfg)
      } else {
        slidesToKeep.push(...categories.mfg)
      }
      if (!cat52.checked) {
        //get category
        slidesToDelete.push(...categories.fins)
      } else {
        slidesToKeep.push(...categories.fins)
      }
      if (!cat53.checked) {
        //get category
        slidesToDelete.push(...categories.tech)
      } else {
        slidesToKeep.push(...categories.tech)
      }
      if (!cat54.checked) {
        //get category
        slidesToDelete.push(...categories.life)
      } else {
        slidesToKeep.push(...categories.life)
      }
      if (!cat55.checked) {
        //get category
        slidesToDelete.push(...categories.media)
      } else {
        slidesToKeep.push(...categories.media)
      }
      if (!cat56.checked) {
        //get category
        slidesToDelete.push(...categories.nonprofit)
      } else {
        slidesToKeep.push(...categories.nonprofit)
      }
      if (!cat57.checked) {
        //get category
        slidesToDelete.push(...categories.proserv)
      } else {
        slidesToKeep.push(...categories.proserv)
      }
      if (!cat58.checked) {
        //get category
        slidesToDelete.push(...categories.real)
      } else {
        slidesToKeep.push(...categories.real)
      }
      if (!cat59.checked) {
        //get category
        slidesToDelete.push(...categories.retail)
      } else {
        slidesToKeep.push(...categories.retail)
      }
      if (!cat510.checked) {
        //get category
        slidesToDelete.push(...categories.travel)
      } else {
        slidesToKeep.push(...categories.travel)
      }

      //get size of business
      if (!cat61.checked) {
        //get category
        slidesToDelete.push(...categories.ebu)
      } else {
        slidesToKeep.push(...categories.ebu)
      }
      if (!cat62.checked) {
        //get category
        slidesToDelete.push(...categories.cbu)
      } else {
        slidesToKeep.push(...categories.cbu)
      }


      //if unchecked add slideId to delete array
      //if checked remove from delete array

      //remove keep slides from delete array
      const uniqueSlidesToDelete = slidesToDelete.filter(onlyUnique)
      const uniqueSlidesToKeep = slidesToKeep.filter(onlyUnique)

      //remove keep slides from delete
      const deleteTheseSlides = uniqueSlidesToDelete.filter((i) => (uniqueSlidesToKeep.indexOf(i) === -1));

      //create delete requests
      const deleteRequests = deleteTheseSlides.map(id => {
        return deleteObj(id)
      });

      //combine name changes with delete requests
      requests.push(...deleteRequests);

      // Delete the slides
      gapi.client.slides.presentations.batchUpdate({
        presentationId: presentationCopyId,
        requests: requests
      }).then((batchUpdateResponse) => {
        console.log('New Deck Complete!')

        newSlide('https://docs.google.com/presentation/d/' + presentationCopyId + "/edit")
      });

    });





  }, function (response) {
    console.log(JSON.stringify(response));
    console.log('Error: ' + response.result.error.message);
  });


};


/**
* Append a pre element to the body containing the given message
* as its text node. Used to display the results of the API call.
*
             * @param {string} message Text to be placed in pre element.
  */
function appendPre(message) {
  var pre = document.getElementById('content');
  var textContent = document.createTextNode(message + '\n');
  //pre.appendChild(textContent);
}

function newSlide(url) {
  const urlLink = document.getElementById('new-deck');
  urlLink.href = url;
  urlLink.innerHTML = "Your custom deck --> " + url;
}

function createRequest(objectId, type, text) {

  var request = {}

  if (type === "update") {
    var request = [{
      deleteText: {
        objectId: objectId,
        textRange: {
          type: 'ALL'
        }
      }
    }, {
      insertText: {
        objectId: objectId,
        insertionIndex: 0,
        text: text
      }
    }];
  }

  return request;

}

function addUnique(array, text) {
  if (array.indexOf(text) == -1) {
    array.push(text);
  }
}

function removeFromArray(arr) {
  var what, a = arguments,
    L = a.length,
    ax;
  while (L > 1 && arr.length) {
    what = a[--L];
    while ((ax = arr.indexOf(what)) !== -1) {
      arr.splice(ax, 1);
    }
  }
  return arr;
}

function onlyUnique(value, index, self) {
  return self.indexOf(value) === index;
}

function deleteObj(id) {
  const obj = {
    deleteObject: {
      objectId: id
    }
  }
  return obj;
}




/**
* Prints the number of slides and elements in a sample presentation:
* https://docs.google.com/presentation/d/1EAYk18WDjIG-zp_0vLm3CsfQh_i8eXc67Jo2O9C6Vuc/edit
https://docs.google.com/presentation/d/1fHxwC_fLIv6HMZfJ13LYzMIZjOYBbZ2PqKy6l8U8Q2s/edit?usp=sharing
https://docs.google.com/presentation/d/1lyNUCcLTYvQbT6YB3L0RTyK-OZccdF-p8Q_UMQVwTX8/edit?usp=sharing
*/
function listSlides() {
  gapi.client.slides.presentations.get({
    presentationId: ogSlideId
  }).then(function (response) {
    var presentation = response.result;
    var length = presentation.slides.length;

    appendPre('The presentation contains ' + length + ' slides:');
    for (var i = 0; i < length; i++) {

      console.log("slide number");
      console.log(i);

      var slide = presentation.slides[i];

      appendPre('- Slide #' + (i + 1) + ' contains ' +
        slide.pageElements.length + ' elements.')
    }
  }, function (response) {
    appendPre('Error: ' + response.result.error.message);
  });
}