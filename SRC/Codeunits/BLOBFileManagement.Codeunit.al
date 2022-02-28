codeunit 50102 "BLOBFileManagement"
{
    procedure CreateNewFile(Folder: Integer; FileName: Text[50]): Integer
    var
        BlobFile: Record "BLOB File";
    begin
        BlobFile.Init();
        BlobFile.Type := BlobFile.Type::File;
        BlobFile."Parent ID" := Folder;
        BlobFile.Name := FileName;
        BlobFile.Insert();
        exit(BlobFile.ID);
    end;

    procedure CreateNewFolder(Folder: Integer; FolderName: Text[50]): Integer
    var
        BlobFile: Record "BLOB File";
    begin
        BlobFile.Init();
        BlobFile.Type := BlobFile.Type::Folder;
        BlobFile."Parent ID" := Folder;
        BlobFile.Name := FolderName;
        BlobFile.Insert();
        exit(BlobFile.ID);
    end;

    procedure DownloadFile(FileID: Integer)
    var
        BlobFile: Record "BLOB File";
        lOutStream: OutStream;
        lInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
    begin
        BlobFile.SetRange(ID, FileID);
        if not BlobFile.FindFirst() then exit;
        BlobFile.CalcFields(BLOB);
        BlobFile.BLOB.CreateInStream(lInStream);
        TempBlob.CreateOutStream(lOutStream);
        CopyStream(lOutStream, lInStream);
        FileMgt.BLOBExport(TempBlob, BlobFile.Name, true);
    end;

    procedure ImportFile(FolderID: Integer)
    var
        TempBlob: Codeunit "Temp Blob";
        lInStream: InStream;
        lOutStream: OutStream;
        FileMgt: Codeunit "File Management";
        BlobFile: Record "BLOB File";
        FileName: Text;
    begin
        TempBlob.CreateInStream(lInStream);
        UploadIntoStream('Select a file to import', '', 'All Files (*.*)|*.*', FileName, lInStream);
        BlobFile.Init();
        BlobFile."Parent ID" := FolderID;
        BlobFile.Name := FileName;
        BlobFile.Type := BlobFile.Type::File;
        BlobFile.Insert();
        BlobFile.BLOB.CreateOutStream(lOutStream);
        CopyStream(lOutStream, lInStream);
        BlobFile.Modify();
    end;

    procedure OpenFileDialog() FileID: Integer;
    var
        FileBroswer: Page "File Browser Lookup";
    begin
        FileBroswer.LookupMode(true);
        if FileBroswer.RunModal = Action::LookupOK then begin
            FileID := FileBroswer.GetSelectedFile();
            exit(FileID);
        end;
        exit(FileID);
    end;

    procedure SaveFileDialog(var lFileName: Text[50]; var lFolder: Integer)
    var
        FileBroswer: Page "File Browser Lookup";
        BlobFile: Record "BLOB File";
    begin
        FileBroswer.LookupMode(true);
        if FileBroswer.RunModal = Action::LookupOK then begin
            FileBroswer.GetFileToSave(lFileName, lFolder);
            if lFileName <> '' then begin
                BlobFile.Reset();
                BlobFile.SetRange("Parent ID", lFolder);
                BlobFile.SetRange(Name, lFileName);
                if BlobFile.FindFirst() then
                    if not Dialog.Confirm(FileFoundConfirm, true, BlobFile.Name) then begin
                        lFileName := '';
                        lFolder := 0;
                    end else begin
                        lFileName := BlobFile.Name;
                        lFolder := BlobFile."Parent ID";
                    end;
            end;
        end;
    end;

    var
        FileFoundConfirm: Label 'The file %1 already exists within the selected directory. Overwrite?';

}