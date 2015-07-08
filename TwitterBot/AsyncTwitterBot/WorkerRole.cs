using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using Microsoft.WindowsAzure;
using Microsoft.WindowsAzure.ServiceRuntime;
using Microsoft.WindowsAzure.Storage;
using TweetSharp;
using Microsoft.WindowsAzure.Storage.Table;

namespace AsyncTwitterBot
{
    public class WorkerRole : RoleEntryPoint
    {
        /* Obtener esta información en: https://apps.twitter.com/app/new */
        private string API_key = "a7XNnibJeQlvkCltGMKHgoOcX";
        private string API_secret = "lrSsfm4lIEuWKYF3qfEqFwxKv9TYSaNPV6eCJTuJD2vnB2FThO";
        private string Access_token_secret = "m1E7h6336AAWHqDdlVRCQ6cDB6DJhCHJfhp1De41WlYaA";
        private string Access_token = "132584323-dYSyJlClws5c3pzdYJRQdjcItOnI5ISUBMjG7ElH";

        private readonly List<TwitterSearchRow> _initialQueries = new List<TwitterSearchRow>
        {
            new TwitterSearchRow("#hacking"),
            new TwitterSearchRow("#infosec"),
            new TwitterSearchRow("#tutoriales"),
            new TwitterSearchRow("#Seguridad")
        };

        private const string PartitionKey = "PK";
        private const string TableName = "metadata";

        private List<TwitterSearchRow> Queries { get; set; }

        public CloudTable MetadataTable { get; set; }
        public TwitterService TwitterServiceInstance { get; set; }

        public override void Run()
        {
            // In v1.1, all API calls require authentication
            TwitterServiceInstance = new TwitterService(API_key, API_secret);
            TwitterServiceInstance.AuthenticateWith(Access_token, Access_token_secret);
            
            Queries = GetQueries();

            
            while (true)
            {
                Thread.Sleep(15 * 60 * 1000);
                
                foreach (var query in Queries)
                {
                    try
                    {
                        ProcessQuery(query);
                        Trace.TraceError("OK bro: " + query.RowKey);
                    }
                    catch
                    {
                        Trace.TraceError("ER bro: " + query.RowKey);
                    }
                }

                PersistQueryTable(Queries);
            }
        }

        private List<TwitterSearchRow> GetQueries()
        {
            var storageAccount = CloudStorageAccount.Parse(CloudConfigurationManager.GetSetting("StorageConnectionString"));
            var tableClient = storageAccount.CreateCloudTableClient();
            var table = tableClient.GetTableReference(TableName);
            MetadataTable = table;

            if (!table.Exists())
            {
                table.CreateIfNotExists();
                return _initialQueries;
            }

            var query = new TableQuery<TwitterSearchRow>().Where(TableQuery.GenerateFilterCondition("PartitionKey", QueryComparisons.Equal, PartitionKey));
            return table.ExecuteQuery(query).ToList();
        }

        public void ProcessQuery(TwitterSearchRow query)
        {
            var searchResults = TwitterServiceInstance.Search(new SearchOptions
            {
                Count = 9, //TODO: este count tiene que ser 15 dividido la cantidad de queries
                Q = query.SearchTerm,
                SinceId = query.LastQueryId,
                Resulttype = TwitterSearchResultType.Popular,
            });

            if (!searchResults.Statuses.Any()) return;

            foreach (var tweet in searchResults.Statuses)
            {
                TwitterServiceInstance.FavoriteTweet(new FavoriteTweetOptions { Id = tweet.Id });
                query.FavouritedTW++;
            }

            query.LastQueryId = searchResults.Statuses.Max(x => x.Id);
        }
        
        private void PersistQueryTable(IEnumerable<TwitterSearchRow> queries)
        {
            var batchOperation = new TableBatchOperation();
            foreach(var query in queries)
            {
                batchOperation.InsertOrReplace(query);
            }
            MetadataTable.ExecuteBatch(batchOperation);
        }
    }

    public class TwitterSearchRow : TableEntity
    {
        public TwitterSearchRow(string searchTerm)
        {
            PartitionKey = "PK";
            RowKey = searchTerm.Replace("#","");
            SearchTerm = searchTerm;
        }

        public string SearchTerm { get; set; }

        public TwitterSearchRow() { }

        public long LastQueryId { get; set; }

        public int FavouritedTW { get; set; }
    }
}
