table 50001 "Basic BLOB File"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name';
        }
        field(2; "BLOB"; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'BLOB';
        }
    }

    keys
    {
        key(key1; "Name")
        {
            Clustered = true;
        }
    }

}