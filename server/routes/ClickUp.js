const router = require("express").Router();

//get a list of authorized workspaces
router.route( "/teams").post(
    async (req, res) => {
      const resp = await fetch(`https://api.clickup.com/api/v2/team`, {
        method: "GET",
        headers: {
          Authorization: `req.body.token`,
        },
      });
  
      const data = await resp.body;
      // console.log(data);
      res.status(200).json(data);
    }
  );
  
  //get list of Spaces in a Workspace
  router.route( "/spaces").post(
    async (req, res) => {
      const query = new URLSearchParams({
        archived: "false",
      }).toString();
  
      const teamId = req.body.teamId;
      const resp = await fetch(
        `https://api.clickup.com/api/v2/team/${teamId}/space?${query}`,
        {
          method: "GET",
          headers: {
            Authorization: `Bearer ${req.body.token}`,
          },
        }
      );
  
      const data = await resp.text();
      console.log(data);
      res.status(200).json(data);
    }
  );
  
  //get a Space in a Workspace
  router.route( "/spaces").post(
    async (req, res) => {
      const query = new URLSearchParams({
        archived: "false",
      }).toString();
  
      const spaceId = req.body.spaceId;
      const resp = await fetch(
        `https://api.clickup.com/api/v2/space/${spaceId}`,
        {
          method: "GET",
          headers: {
            Authorization: `Bearer ${req.body.token}`,
          },
        }
      );
      const data = await resp.json();
      res.status(200).json(data);
    }
  );
  
  //get list of Folders in a Workspace
  router.route( "/folders").post(
    async (req, res) => {
      const query = new URLSearchParams({
        archived: "false",
      }).toString();
  
      const spaceId = req.body.spaceId;
      const resp = await fetch(
        `https://api.clickup.com/api/v2/space/${spaceId}/folder?${query}`,
        {
          method: "GET",
          headers: {
            Authorization: `Bearer ${req.body.token}`,
          },
        }
      );
  
      const data = await resp.text();
      console.log(data);
      res.status(200).json(data);
    }
  );
  
  //get a Folder in a Workspace
  router.route( "/folder").post(
    async (req, res) => {
      const query = new URLSearchParams({
        archived: "false",
      }).toString();
  
      const folderId = req.body.folderId;
      const resp = await fetch(
        `https://api.clickup.com/api/v2/folder/${folderId}`,
        {
          method: "GET",
          headers: {
            Authorization: `Bearer ${req.body.token}`,
          },
        }
      );
  
      const data = await resp.json();
      console.log(data);
      res.status(200).json(data);
    }
  );
  
  //get list of folderless lists
  router.route("/folderless/lists").post(
    async (req, res) => {
      const query = new URLSearchParams({
        archived: "false",
      }).toString();
  
      const spaceId = req.body.spaceId;
      const resp = await fetch(
        `https://api.clickup.com/api/v2/space/${spaceId}/list?${query}`,
        {
          method: "GET",
          headers: {
            Authorization: `Bearer ${req.body.token}`,
          },
        }
      );
  
      const data = await resp.text();
      console.log(data);
      res.status(200).json(data);
    }
  );
  
  //get list of lists
  router.route("/lists").post(

    async (req, res) => {
      const query = new URLSearchParams({
        archived: "false",
      }).toString();
  
      const folderId = req.body.folderId;
      const resp = await fetch(
        `https://api.clickup.com/api/v2/folder/${folderId}/list?${query}`,
        {
          method: "GET",
          headers: {
            Authorization: `Bearer ${req.body.token}`,
          },
        }
      );
  
      const data = await resp.text();
      console.log(data);
      res.status(200).json(data);
    }
  );
  
  //get single list
  router.route("/list").post(

    async (req, res) => {
      const query = new URLSearchParams({
        archived: "false",
      }).toString();
  
      const listId = req.body.listId;
      const resp = await fetch(
        `https://api.clickup.com/api/v2/list/${listId}`,
        {
          method: "GET",
          headers: {
            Authorization: `Bearer ${req.body.token}`,
          },
        }
      );
  
      const data = await resp.json();
      console.log(data);
      res.status(200).json(data);
    }
  );
  
  //get list of tasks
  router.route("/tasks").post(

    async (req, res) => {
      const query = new URLSearchParams({
        archived: "false",
        // include_markdown_description: 'true',
        // page: '0',
        // order_by: 'string',
        // reverse: 'true',
        // subtasks: 'true',
        // statuses: 'string',
        // include_closed: 'true',
        // assignees: 'string',
        // tags: 'string',
        // due_date_gt: '0',
        // due_date_lt: '0',
        // date_created_gt: '0',
        // date_created_lt: '0',
        // date_updated_gt: '0',
        // date_updated_lt: '0',
        // date_done_gt: '0',
        // date_done_lt: '0',
        // custom_fields: 'string',
        // custom_items: '0'
      }).toString();
  
      const listId = req.body.listId;
      const resp = await fetch(
        `https://api.clickup.com/api/v2/list/${listId}/task?${query}`,
        {
          method: "GET",
          headers: {
            Authorization: `Bearer ${req.body.token}`,
          },
        }
      );
  
      const data = await resp.text();
      console.log(data);
      res.status(200).json(data);
    }
  );

//ok so I can see this works in theory but using ngrok to create an API gateway so ClickUp can 
//reach my localhost sever it hits a sort of paywall. But in the ngrok dashboard I can see the
//webhook is received.
router.route("/webhook").post( (req, res) => {
    const data = req.body;

    if (!data || !data.event) {
        return res.status(400).send('Bad Request');
      }
    
      // Process datas
      console.log('Received webhook event:', data.event);
      req.io.emit("Webhook Payload Received", data);
    
      // Send response
      res.status(200).send('Webhook received');
})

router.route("/test").get((req, res) => {
    res.send("test complete")
})



module.exports = router;