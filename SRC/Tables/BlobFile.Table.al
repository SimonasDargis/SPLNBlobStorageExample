table 50000 "BLOB File"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; Enum "BLOB File Types")
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
        }
        field(2; "ID"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Parent ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
        }
        field(4; "Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name';
        }
        field(10; "BLOB"; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'BLOB';
        }
    }

    keys
    {
        key(key1; "Type", "ID")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        BlobFile: Record "BLOB File";
    begin
        if Rec.Type = Rec.Type::Folder then begin
            BlobFile.SetRange("Parent ID", Rec.ID);
            if BlobFile.FindSet() then
                BlobFile.DeleteAll(true);
        end;
    end;

}