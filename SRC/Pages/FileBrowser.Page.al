page 50100 "File Browser"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BLOB File";
    //DeleteAllowed = false;
    InsertAllowed = false;
    Caption = 'File Browser';

    layout
    {
        area(Content)
        {
            Repeater(ItemList)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    trigger OnDrillDown()
                    var
                        FileBrowser: Page "File Browser";
                        FileMgt: Codeunit BLOBFileManagement;
                    begin
                        if Rec.Type = Rec.Type::Folder then begin
                            FileBrowser.SetCurrentFolder(Rec.ID);
                            FileBrowser.RunModal();
                        end else begin
                            FileMgt.DownloadFile(Rec.ID);
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewFolder)
            {
                ApplicationArea = All;
                Caption = 'New Folder';
                Image = Journal;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = New;
                trigger OnAction()
                var
                    FileMgt: Codeunit BLOBFileManagement;
                begin
                    FileMgt.CreateNewFolder(CurrentFolder, 'New Folder');
                end;
            }
            action(NewFile)
            {
                ApplicationArea = All;
                Caption = 'New File';
                Image = BeginningText;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = New;
                trigger OnAction()
                var
                    FileMgt: Codeunit BLOBFileManagement;
                begin
                    FileMgt.CreateNewFile(CurrentFolder, 'New File');
                end;
            }
            action(ImportFile)
            {
                ApplicationArea = All;
                Caption = 'Import File';
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = New;
                trigger OnAction()
                var
                    FileMgt: Codeunit BLOBFileManagement;
                begin
                    FileMgt.ImportFile(CurrentFolder);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        UpdateList();
    end;

    procedure SetCurrentFolder(CurrFolder: Integer)
    begin
        CurrentFolder := CurrFolder;
    end;

    local procedure UpdateList()
    begin
        Rec.Reset();
        Rec.SetRange("Parent ID", CurrentFolder);
        CurrPage.Update();
    end;

    var
        CurrentFolder: Integer;
}

